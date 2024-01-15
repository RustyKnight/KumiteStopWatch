//
//  PieSliceViewController.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 27/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import AudioToolbox
import KZCoreUILibrary
import Cadmus

@IBDesignable class StopWatchView: UIView {
    
    private let conicalFillPieSliceProgressLayer = ConicalFillPieSliceProgressLayer()
    private let overlayLayer = OverlayLayer()
    private let flashLayer = FlashLayer()
    
    var stopWatchDelegate: StopWatchDelegate?
    
    @IBInspectable var progressLineWidth: CGFloat {
        set(newValue) {
            conicalFillPieSliceProgressLayer.lineWidth = newValue
            setNeedsDisplay()
        }
        
        get {
            return conicalFillPieSliceProgressLayer.lineWidth
        }
    }
    
    @IBInspectable var progressStrokeColor: UIColor? {
        set(newValue) {
            conicalFillPieSliceProgressLayer.strokeColor = newValue
            setNeedsDisplay()
        }
        
        get {
            return conicalFillPieSliceProgressLayer.strokeColor
        }
    }
    
    @IBInspectable var overlayFillColor: UIColor? {
        set(newValue) {
            if let color = newValue {
                overlayLayer.fillColor = color.cgColor
            } else {
                overlayLayer.fillColor = nil
            }
            setNeedsDisplay()
        }
        
        get {
            var fillColor: UIColor?
            if let color = overlayLayer.fillColor {
                fillColor = UIColor(cgColor: color)
            }
            return fillColor
        }
    }
    
    @IBInspectable var overlayStrokeColor: UIColor? {
        set(newValue) {
            if let color = newValue {
                overlayLayer.strokeColor = color.cgColor
            } else {
                overlayLayer.strokeColor = nil
            }
            setNeedsDisplay()
        }
        
        get {
            var fillColor: UIColor?
            if let color = overlayLayer.strokeColor {
                fillColor = UIColor(cgColor: color)
            }
            return fillColor
        }
    }
    
    @IBInspectable var overlayShadowColor: UIColor? {
        set(newValue) {
            if let color = newValue {
                overlayLayer.shadowColor = color.cgColor
            } else {
                overlayLayer.shadowColor = nil
            }
            setNeedsDisplay()
        }
        
        get {
            var fillColor: UIColor?
            if let color = overlayLayer.shadowColor {
                fillColor = UIColor(cgColor: color)
            }
            return fillColor
        }
    }
    
    @IBInspectable var overlayShadowOpacity: Float {
        set(newValue) {
            overlayLayer.shadowOpacity = newValue
            setNeedsDisplay()
        }
        
        get {
            return overlayLayer.shadowOpacity
        }
    }
    
    @IBInspectable var overlayFillScale: Float {
        set(newValue) {
            overlayLayer.fillScale = newValue
            flashLayer.fillScale = newValue
            tickLayer.radiusScale = newValue
            for tickLayer in timeLineTickLayers {
                tickLayer.radiusScale = newValue
            }
            setNeedsLayout()
            setNeedsDisplay()
        }
        
        get {
            return overlayLayer.fillScale
        }
    }
    
    @IBInspectable var tickFillColor: UIColor? {
        set(newValue) {
            if let color = newValue {
                tickLayer.fillColor = color
            } else {
                tickLayer.fillColor = nil
            }
            setNeedsDisplay()
        }
        
        get {
            return tickLayer.fillColor
        }
    }
    
    @IBInspectable var tickStrokeColor: UIColor? {
        set(newValue) {
            if let color = newValue {
                tickLayer.strokeColor = color
            } else {
                tickLayer.strokeColor = nil
            }
            setNeedsDisplay()
        }
        
        get {
            return tickLayer.strokeColor
        }
    }
    
    var timeLine: TimeLine? {
        didSet {
            updateTimeLine()
        }
    }
    
    // This is used to maintain a tempory list of
    // events while animation is running, this way
    // I can popup off events as they occur and not
    // waste time iterating over the list
    private var eventList: [TimeLineEvent]?
    
    private let animationManager: AnimationManager = AnimationManager()
    
    private let textLayer: TextLayer = TextLayer()
    private let tickLayer: TickLayer = TickLayer()
    
    private var timeLineTickLayers: [TickLayer] = []
    
    private var colorfuls: [Colorful] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
        animationManager.animatables.append(conicalFillPieSliceProgressLayer)
        animationManager.animatables.append(tickLayer)
        animationManager.animatables.append(textLayer)
        animationManager.animatables.append(flashLayer)
        
        colorfuls.append(textLayer)
        colorfuls.append(tickLayer)
        colorfuls.append(conicalFillPieSliceProgressLayer)
        
        tickLayer.progress = 0.0
        
        overlayLayer.fillColor = UIColor.black.cgColor
        overlayLayer.strokeColor = UIColor.darkGray.cgColor
        overlayLayer.shadowColor = UIColor.yellow.cgColor
        overlayLayer.shadowOffset = .zero
        overlayLayer.shadowOpacity = 0.5
        
        progressLineWidth = 1
        progressStrokeColor = .white
        
        conicalFillPieSliceProgressLayer.frame = bounds
        overlayLayer.frame = bounds
        flashLayer.frame = bounds
        textLayer.frame = bounds
        
        layer.addSublayer(conicalFillPieSliceProgressLayer)
        layer.addSublayer(overlayLayer)
        layer.addSublayer(flashLayer)
        layer.addSublayer(tickLayer)
        layer.addSublayer(textLayer)
        
        flashLayer.animationDelegate = self
        
        updateTimeLine()
    }
    
    func updateTimeLine() {
        stop(andReset: true)
        eventList = nil
        for tickLayer in timeLineTickLayers {
            tickLayer.removeFromSuperlayer()
        }
        timeLineTickLayers.removeAll()
        if let timeLine = timeLine {
            if timeLine.events.count > 2 {
                for index in 1...timeLine.events.count - 2 {
                    let evt = timeLine.events[index]
                    let tick = TickLayer(timeLineEvent: evt)
                    tick.radiusScale = tickLayer.radiusScale
                    tick.frame = bounds
                    
                    timeLineTickLayers.append(tick)
                    layer.addSublayer(tick)
                }
            }
        }
        
        var colorband: ColorBand?
        if let timeLine = timeLine {
            colorband = timeLine.colorBand
        }
        for var colorful in colorfuls {
            colorful.colorBand = colorband
        }
        
        flashLayer.timeLine = timeLine
        
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        conicalFillPieSliceProgressLayer.frame = bounds
        overlayLayer.frame = bounds
        tickLayer.frame = bounds
        textLayer.frame = bounds
        flashLayer.frame = bounds
        
        for tick in timeLineTickLayers {
            tick.frame = bounds
            tick.setNeedsLayout()
            tick.setNeedsDisplay()
        }
    }
    
}

extension StopWatchView: CAAnimationDelegate {
    
    func currentAnimationState() -> AnimationState {
        return animationManager.currentState()
    }
    
    func start() {
        if let timeLine = timeLine {
            UIApplication.shared.isIdleTimerDisabled = true
            animationManager.start(withDurationOf: timeLine.duration, withDelegate: self)
            overlayLayer.startAnimation()
        }
    }
    
    func stop(andReset reset: Bool = false) {
        UIApplication.shared.isIdleTimerDisabled = false
        animationManager.stop(andReset: reset)
        overlayLayer.stopAnimation(andReset: reset)
        stopWatchStateDidChange()
    }
    
    func pause() {
        if let timeLine = timeLine {
            if timeLine.pausable && animationManager.currentState() == .running {
                animationManager.pause()
                stopWatchStateDidChange()
            }
        }
    }
    
    func resume() {
        if let timeLine = timeLine {
            if timeLine.pausable && animationManager.currentState() == .paused {
                animationManager.resume()
                stopWatchStateDidChange()
            }
        }
    }
    
    func reset() {
        if timeLine != nil {
            if currentAnimationState() == .paused {
                resume()
            }
            stop(andReset: true)
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        prepareEvents()
        stopWatchStateDidChange()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let eventList = eventList {
            if let event = eventList.first {
                // Is there one last event?
                if event.location == 1.0 {
                    // Flashing is taken care of by the FlashLayer
                    if event.alerts.contains(TimeLineAlert.Vibrate) {
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                }
            }
        }
        eventList = nil
        stop()
    }
    
    func stopWatchStateDidChange() {
        if let stopWatchDelegate = stopWatchDelegate {
            stopWatchDelegate.stopWatch(self, stateDidChange: animationManager.currentState())
        }
    }
    
    func prepareEvents() {
        if eventList == nil {
            if let timeLine = timeLine {
                eventList = []
                let oneSecond = 1.0 / timeLine.duration
                let colorBand = timeLine.colorBand
                for evt in timeLine.events {
                    if evt.alerts.contains(TimeLineAlert.Vibrate) {
                        // We want three events, 1 second apart up
                        for i in stride(from: 2, to: -1, by: -1) {
                            let time = evt.location - (oneSecond * Double(i))
                            // Must be postive
                            if (time == abs(time)) {
                                eventList!.append(TimeLineEvent(location: time, color: colorBand.colorAt(time), alerts: [TimeLineAlert.Vibrate]))
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension StopWatchView: AnimationProgressDelegate {
    func animationProgressedTo(_ progress: Double) {
        if let eventList = eventList {
            if let next = eventList.first {
                if progress >= next.location {
                    if next.alerts.contains(TimeLineAlert.Vibrate) {
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                }
                
                if progress >= next.location {
                    self.eventList!.remove(at: 0)
                }
            }
        }
    }
}

class OverlayLayer: CAShapeLayer {
    
    var fillScale: Float = 0.75 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override init() {
        super.init()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? OverlayLayer {
            fillScale = layer.fillScale
        }
    }
    
    func configure() {
        fillColor = UIColor.black.cgColor
        strokeColor = UIColor.darkGray.cgColor
        shadowColor = UIColor.yellow.cgColor
        shadowOffset = CGSize(width: 0, height: 0)
        shadowOpacity = 0.5
        shadowRadius = 20
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let diameter = bounds.minDimension()
        let scaledSize = diameter * fillScale.toCGFloat
        let centerX = (bounds.width - scaledSize) / 2
        let centerY = (bounds.height - scaledSize) / 2
        
        path = UIBezierPath(ovalIn: CGRect(x: centerX, y: centerY, width: scaledSize, height: scaledSize)).cgPath
    }
    
    func startAnimation() {
        removeAnimation(forKey: "shadowOpacity")
        
        let currentValue = shadowOpacity
        
        let anim = CAKeyframeAnimation(keyPath: "shadowOpacity")
        anim.values = [currentValue, 0.75, 0.25]
        anim.keyTimes = [0.0, 0.5, 1.0]
        anim.autoreverses = true
        anim.duration = 4.0
        anim.repeatCount = MAXFLOAT
        add(anim, forKey: "shadowOpacity")
    }
    
    func stopAnimation(andReset reset: Bool) {
        removeAnimation(forKey: "shadowOpacity")
    }
    
}

protocol AnimationProgressDelegate {
    func animationProgressedTo(_ progress: Double);
}

// The intention for this is to provide the time line background flashing
// effect
// The reason for doing this here is because the OverlayLayer animates its
// opacity continuiously, while the stop watch is "running" (including when
// paused), which doesn't help the background flashing side of things
class FlashLayer: OverlayLayer, Animatable, CAAnimationDelegate {
    var timeLine: TimeLine?
    var progress: Double = 0.0
    var animationDelegate: AnimationProgressDelegate?
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? FlashLayer {
            timeLine = layer.timeLine
            progress = layer.progress
            animationDelegate = layer.animationDelegate
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func configure() {
        super.configure()
        fillColor = UIColor.clear.cgColor
        strokeColor = nil
        shadowColor = nil
        shadowOpacity = 0.0
    }
    
    /*
     Override actionForKey: and return a CAAnimation that prepares the animation for that property.
     In our case, we will return an animation for the progress property.
     */
    override func action(forKey event: String) -> CAAction? {
        var action: CAAction?
        if event == "progress" {
            action = self.animation(forKey: event)
        } else {
            action = super.action(forKey: event)
        }
        return action
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        var needsDisplay = false
        if key == "progress" {
            needsDisplay = true
        } else {
            needsDisplay = super.needsDisplay(forKey: key)
        }
        return needsDisplay
    }
    
    override func draw(in ctx: CGContext) {
        if let delegate = animationDelegate {
            delegate.animationProgressedTo(progress)
        }
    }
    
    func startAnimation(withDurationOf duration: Double, withDelegate: CAAnimationDelegate?) {
        removeAnimation(forKey: "fillColor")
        
        if let timeLine = timeLine {
            let delay = 1.0 / timeLine.duration
            let milliBefore = 0.001 / timeLine.duration
            let events = Array(timeLine.events[1..<timeLine.events.count])
            if events.count > 0 {
                
                let keyAnim = CAKeyframeAnimation(keyPath: "fillColor")
                keyAnim.duration = timeLine.duration
                
                var colors: [CGColor] = [UIColor.clear.cgColor]
                var locations: [Double] = [0.0]
                for evt in events {
                    if evt.alerts.contains(TimeLineAlert.FlashBackground) {
                        let location = evt.location
                        colors.append(UIColor.clear.cgColor)
                        locations.append((location - (delay * 2)) - milliBefore)
                        for i in stride(from: 2, to: -1, by: -1) {
                            let time = location - (delay * Double(i))
                            colors.append(timeLine.colorBand.colorAt(time).darken(by: 0.5).cgColor)
                            locations.append(time)
                            
                            let endTime = time + delay - milliBefore
                            colors.append(UIColor.clear.cgColor)
                            locations.append(endTime)
                        }
                    }
                }
                
                let keys = locations.map { NSNumber(floatLiteral: $0) }
                
                keyAnim.values = colors
                keyAnim.keyTimes = keys
                keyAnim.delegate = self
                add(keyAnim, forKey: "fillColor")
            }
            
            let anim = CABasicAnimation(keyPath: "progress")
            //			anim.delegate = withDelegate
            anim.fromValue = 0
            anim.toValue = 1.0
            anim.duration = duration
            add(anim, forKey: "progress")
        }
    }
    
    override func stopAnimation(andReset reset: Bool) {
        removeAnimation(forKey: "fillColor")
        removeAnimation(forKey: "progress")
        if (reset) {
            progress = 0.0
        }
    }
    
    func animationDidStart(_ anim: CAAnimation) {
    }
    
    func animationDidStop(_ anim: CAAnimation, finished: Bool) {
        guard finished else { return }
        guard
            let timeLine,
            let evt = timeLine.events.last,
            evt.alerts.contains(TimeLineAlert.FlashBackground)
        else { return }
        
        let color = timeLine.colorBand.colorAt(1.0)
        let anim = CABasicAnimation(keyPath: "fillColor")
        anim.fromValue = color.cgColor
        anim.toValue = UIColor.clear.cgColor
        anim.duration = 1.0
        add(anim, forKey: "lastFillColor")
    }
    
}
