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

@IBDesignable public class StopWatchView: UIView {
	
	private let conicalFillPieSliceProgressLayer: ConicalFillPieSliceProgressLayer = ConicalFillPieSliceProgressLayer()
	private let overlayLayer: OverlayLayer = OverlayLayer()
	private let flashLayer: FlashLayer = FlashLayer()
	
	public var stopWatchDelegate: StopWatchDelegate?
	
	@IBInspectable public var progressLineWidth: CGFloat {
		set(newValue) {
			conicalFillPieSliceProgressLayer.lineWidth = newValue
			setNeedsDisplay()
		}
		
		get {
			return conicalFillPieSliceProgressLayer.lineWidth
		}
	}
	
	@IBInspectable public var progressStrokeColor: UIColor? {
		set(newValue) {
			conicalFillPieSliceProgressLayer.strokeColor = newValue
			setNeedsDisplay()
		}
		
		get {
			return conicalFillPieSliceProgressLayer.strokeColor
		}
	}
	
	@IBInspectable public var overlayFillColor: UIColor? {
		set(newValue) {
			if let color = newValue {
				overlayLayer.fillColor = color.CGColor
			} else {
				overlayLayer.fillColor = nil
			}
			setNeedsDisplay()
		}
		
		get {
			var fillColor: UIColor?
			if let color = overlayLayer.fillColor {
				fillColor = UIColor(CGColor: color)
			}
			return fillColor
		}
	}

	@IBInspectable public var overlayStrokeColor: UIColor? {
		set(newValue) {
			if let color = newValue {
				overlayLayer.strokeColor = color.CGColor
			} else {
				overlayLayer.strokeColor = nil
			}
			setNeedsDisplay()
		}
		
		get {
			var fillColor: UIColor?
			if let color = overlayLayer.strokeColor {
				fillColor = UIColor(CGColor: color)
			}
			return fillColor
		}
	}
	
	@IBInspectable public var overlayShadowColor: UIColor? {
		set(newValue) {
			if let color = newValue {
				overlayLayer.shadowColor = color.CGColor
			} else {
				overlayLayer.shadowColor = nil
			}
			setNeedsDisplay()
		}
		
		get {
			var fillColor: UIColor?
			if let color = overlayLayer.shadowColor {
				fillColor = UIColor(CGColor: color)
			}
			return fillColor
		}
	}
	
	@IBInspectable public var overlayShadowOpacity: Float {
		set(newValue) {
			overlayLayer.shadowOpacity = newValue
			setNeedsDisplay()
		}
		
		get {
			return overlayLayer.shadowOpacity
		}
	}

	@IBInspectable public var overlayFillScale: Float {
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
	
	@IBInspectable public var tickFillColor: UIColor? {
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
	
	@IBInspectable public var tickStrokeColor: UIColor? {
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
	
	public var timeLine: TimeLine? {
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
	
//	private var animtables: [ProgressAnimatable] = []
	private var colorfuls: [Colorful] = []
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configure()
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}

	func configure() {
		backgroundColor = UIColor.blackColor()
		
		animationManager.animatables.append(conicalFillPieSliceProgressLayer)
		animationManager.animatables.append(tickLayer)
		animationManager.animatables.append(textLayer)
		animationManager.animatables.append(flashLayer)
		
		colorfuls.append(textLayer)
		colorfuls.append(tickLayer)
		colorfuls.append(conicalFillPieSliceProgressLayer)
		
		tickLayer.progress = 0.0

		overlayLayer.fillColor = UIColor.blackColor().CGColor
		overlayLayer.strokeColor = UIColor.darkGrayColor().CGColor
		overlayLayer.shadowColor = UIColor.yellowColor().CGColor
		overlayLayer.shadowOffset = CGSize(width: 0, height: 0)
		overlayLayer.shadowOpacity = 0.5
		
		progressLineWidth = 1
		progressStrokeColor = UIColor.whiteColor()
		
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
			for index in 1...timeLine.events.count - 2 {
				let evt = timeLine.events[index]
				let tick = TickLayer(timeLineEvent: evt)
				tick.radiusScale = tickLayer.radiusScale
				tick.frame = bounds
				
				timeLineTickLayers.append(tick)
				layer.addSublayer(tick)
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

	public override func layoutSubviews() {
		super.layoutSubviews()
		
		conicalFillPieSliceProgressLayer.frame = bounds
		overlayLayer.frame = bounds
		tickLayer.frame = bounds
		textLayer.frame = bounds
		flashLayer.frame = bounds
		
		for tick in timeLineTickLayers {
			tick.frame = bounds
		}
	}
	
}

public extension StopWatchView {

	public func currentAnimationState() -> AnimationState {
		return animationManager.currentState()
	}
	
	public func start() {
		UIApplication.sharedApplication().idleTimerDisabled = true
		if let timeLine = timeLine {
			animationManager.start(withDurationOf: timeLine.duration, withDelegate: self)
		}
		overlayLayer.startAnimation()
	}
	
	public func stop(andReset reset: Bool = false) {
		UIApplication.sharedApplication().idleTimerDisabled = false
		animationManager.stop(andReset: reset)
		overlayLayer.stopAnimation(andReset: reset)
		stopWatchStateDidChange()
	}
	
	public func pause() {
		animationManager.pause()
		stopWatchStateDidChange()
	}
	
	public func resume() {
		animationManager.resume()
		stopWatchStateDidChange()
	}
	
	public func reset() {
		if currentAnimationState() == .Paused {
			resume()
		}
		stop(andReset: true)
	}
	
	public override func animationDidStart(anim: CAAnimation) {
		prepareEvents()
		stopWatchStateDidChange()
	}
	
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
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
						for i in 2.stride(to: -1, by: -1) {
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
	func animationProgressedTo(progress: Double) {
		if let eventList = eventList {
			if let next = eventList.first {
				if progress >= next.location {
					if next.alerts.contains(TimeLineAlert.Vibrate) {
						AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
					}
				}
//				if let timeLine = timeLine {
//					let oneSecond = 1.0 / timeLine.duration
//					let gap = 0.005 / timeLine.duration
//					
//					if next.alerts.contains(TimeLineAlert.Vibrate) {
//						for i in 2.stride(to: -1, by: -1) {
//							let time = next.location - (oneSecond * Double(i))
//							if time - gap...time + gap ~= progress {
//								print("Within range")
//							}
////							print("Vibrate @ \(time) for \(progress - gap)-\(progress + gap)")
////							if progress - gap >= time && progress + gap <= time {
////								print("Vibrate for \(next.location)")
////							}
//						}
//					}
//					
//					if progress >= next.location - (oneSecond * 2.0) {
////						print("Trigger \(next.location) @ \(progress)")
//					}
				
					if progress >= next.location {
						self.eventList!.removeAtIndex(0)
					}
				}
			}
//		}
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
	
	override init(layer: AnyObject) {
		super.init(layer: layer)
		if let layer = layer as? OverlayLayer {
			fillScale = layer.fillScale
		}
	}
	
	func configure() {
		fillColor = UIColor.blackColor().CGColor
		strokeColor = UIColor.darkGrayColor().CGColor
		shadowColor = UIColor.yellowColor().CGColor
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
		
		path = UIBezierPath(ovalInRect: CGRect(x: centerX, y: centerY, width: scaledSize, height: scaledSize)).CGPath
	}
	
	func startAnimation() {
		
		removeAnimationForKey("shadowOpacity")

		let currentValue = shadowOpacity

		let anim = CAKeyframeAnimation(keyPath: "shadowOpacity")
		anim.values = [currentValue, 0.75, 0.25]
		anim.keyTimes = [0.0, 0.5, 1.0]
		anim.autoreverses = true
		anim.duration = 4.0
		anim.repeatCount = MAXFLOAT
		addAnimation(anim, forKey: "shadowOpacity")
	}
	
	func stopAnimation(andReset reset: Bool) {

		removeAnimationForKey("shadowOpacity")
		
	}
	
}

protocol AnimationProgressDelegate {
	func animationProgressedTo(progress: Double);
}

// The intention for this is to provide the time line background flashing
// effect
// The reason for doing this here is because the OverlayLayer animates its
// opacity continuiously, while the stop watch is "running" (including when
// paused), which doesn't help the background flashing side of things
class FlashLayer: OverlayLayer, Animatable {
	
	var timeLine: TimeLine?
	var progress: Double = 0.0
	var animationDelegate: AnimationProgressDelegate?
	
	override init() {
		super.init()
	}
	
	override init(layer: AnyObject) {
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
		fillColor = UIColor.clearColor().CGColor
		strokeColor = nil
		shadowColor = nil
		shadowOpacity = 0.0
	}
	
	/*
	Override actionForKey: and return a CAAnimation that prepares the animation for that property.
	In our case, we will return an animation for the progress property.
	*/
	override func actionForKey(event: String) -> CAAction? {
		var action: CAAction?
		if event == "progress" {
			action = self.animationForKey(event)
		} else {
			action = super.actionForKey(event)
		}
		return action
	}
	
	override class func needsDisplayForKey(key: String) -> Bool {
		var needsDisplay = false
		if key == "progress" {
			needsDisplay = true
		} else {
			needsDisplay = super.needsDisplayForKey(key)
		}
		return needsDisplay
	}
	
	override func drawInContext(ctx: CGContext) {
		if let delegate = animationDelegate {
			delegate.animationProgressedTo(progress)
		}
	}
	
	func startAnimation(withDurationOf duration: Double, withDelegate: AnyObject?) {
		
		removeAnimationForKey("fillColor")
		
		if let timeLine = timeLine {
			
			let delay = 1.0 / timeLine.duration
			let milliBefore = 0.001 / timeLine.duration
			let events = Array(timeLine.events[1..<timeLine.events.count])
			if events.count > 0 {
				
				let keyAnim = CAKeyframeAnimation(keyPath: "fillColor")
				keyAnim.duration = timeLine.duration
				
				var colors: [CGColor] = [UIColor.clearColor().CGColor]
				var locations: [Double] = [0.0]
				for evt in events {
					if evt.alerts.contains(TimeLineAlert.FlashBackground) {
						
						let location = evt.location
						colors.append(UIColor.clearColor().CGColor)
						locations.append((location - (delay * 2)) - milliBefore)
						
						for i in 2.stride(to: -1, by: -1) {
							
							let time = location - (delay * Double(i))
							colors.append(timeLine.colorBand.colorAt(time).darken(by: 0.5).CGColor)
							locations.append(time)
							
							let endTime = time + delay - milliBefore
							colors.append(UIColor.clearColor().CGColor)
							locations.append(endTime)
						}
						
						
					}
				}
				
				keyAnim.values = colors
				keyAnim.keyTimes = locations
				keyAnim.delegate = self
				addAnimation(keyAnim, forKey: "fillColor")
			}
			
			let anim = CABasicAnimation(keyPath: "progress")
//			anim.delegate = withDelegate
			anim.fromValue = 0
			anim.toValue = 1.0
			anim.duration = duration
			addAnimation(anim, forKey: "progress")
			
		}
	}
	
	override func stopAnimation(andReset reset: Bool) {
		removeAnimationForKey("fillColor")
		removeAnimationForKey("progress")
		if (reset) {
			progress = 0.0
		}
	}
	
	override func animationDidStart(anim: CAAnimation) {
		print("Flash AnimationDidStart")
	}
	
	override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		print("Flash AnimationDidStop with \(flag)")
		if flag {
			if let timeLine = timeLine {
				if let evt = timeLine.events.last {
					if evt.alerts.contains(TimeLineAlert.FlashBackground) {
						let color = timeLine.colorBand.colorAt(1.0)
						let anim = CABasicAnimation(keyPath: "fillColor")
						anim.fromValue = color.CGColor
						anim.toValue = UIColor.clearColor().CGColor
						anim.duration = 1.0
						addAnimation(anim, forKey: "lastFillColor")
					}
				}
			}
		}
	}
	
}