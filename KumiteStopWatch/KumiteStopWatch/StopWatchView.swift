//
//  PieSliceViewController.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 27/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreUILibrary

@IBDesignable public class StopWatchView: UIView {
	
	private let conicalFillPieSliceProgressLayer: ConicalFillPieSliceProgressLayer = ConicalFillPieSliceProgressLayer()
	private let overlayLayer: OverlayLayer = OverlayLayer()
	
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
		layer.addSublayer(conicalFillPieSliceProgressLayer)
		layer.addSublayer(overlayLayer)

		layer.addSublayer(tickLayer)
		
		updateTimeLine()
		
		textLayer.frame = bounds
		layer.addSublayer(textLayer)
	}
	
	func updateTimeLine() {
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
		//			textLayer.timeLine = timeLine
		//			tickLayer.timeLime = timeLine
		//			conicalFillPieSliceProgressLayer.timeLine = timeLine
		setNeedsLayout()
		setNeedsDisplay()
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		
		conicalFillPieSliceProgressLayer.frame = bounds
		overlayLayer.frame = bounds
		tickLayer.frame = bounds
		textLayer.frame = bounds
		
		for tick in timeLineTickLayers {
			tick.frame = bounds
		}
	}
	
	public func currentAnimationState() -> AnimationState {
		return animationManager.currentState()
	}
	
//	public func pauseResume() {
//		switch (animationStateMonitor.currentState()) {
//		case .Stopped:
//			start()
//		case .Running:
//			conicalFillPieSliceProgressLayer.pauseAnimation()
//			tickLayer.pauseAnimation()
//			textLayer.pauseAnimation()
//			animationStateMonitor.paused()
//			stopWatchStateDidChange()
//		case .Paused:
//			conicalFillPieSliceProgressLayer.resumeAnimation()
//			tickLayer.resumeAnimation()
//			textLayer.resumeAnimation()
//			animationStateMonitor.running()
//			stopWatchStateDidChange()
//		}
//	}
//	
//	func start() {
//		if let timeLine = timeLine {
//			let duration = timeLine.duration
//			for animtable in animtables {
//				animtable.animateProgressTo(1.0, withDurationOf: duration, delegate: self)
//			}
//		}
//	}
	
	// This is test code for testing the basic animation, it doesn't really
	// belong here, but should probably be part of the contract with the view controller
	// This would also relies on the concept of the timeline, which will be implemented
	// later
//	override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//		super.touchesBegan(touches, withEvent: event)
//		
//		print("state = \(animationStateMonitor.currentState())")
//		switch (animationStateMonitor.currentState()) {
//		case .Stopped:
//			start()
//		case .Running:
//			conicalFillPieSliceProgressLayer.pauseAnimation()
//			tickLayer.pauseAnimation()
//			textLayer.pauseAnimation()
//			animationStateMonitor.paused()
//		case .Paused:
//			conicalFillPieSliceProgressLayer.resumeAnimation()
//			tickLayer.resumeAnimation()
//			textLayer.resumeAnimation()
//			animationStateMonitor.running()
//		}
//	}
	
	public func start() {
		if let timeLine = timeLine {
			animationManager.start(withDurationOf: timeLine.duration, withDelegate: self)
		}
		overlayLayer.startAnimation()
	}
	
	public func stop(andReset reset: Bool = false) {
		animationManager.stop(andReset: reset)
		overlayLayer.stopAnimation()
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
		stopWatchStateDidChange()
	}
	
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		stop()
	}
	
	func stopWatchStateDidChange() {
		if let stopWatchDelegate = stopWatchDelegate {
			stopWatchDelegate.stopWatch(self, stateDidChange: animationManager.currentState())
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
		anim.values = [currentValue, 0.75, 0.25, currentValue]
		anim.keyTimes = [0.0, 0.33, 0.66, 1.0]
		anim.duration = 4.0
		anim.repeatCount = MAXFLOAT
		//		anim.removedOnCompletion = false
		//		anim.additive = true
		//		anim.fillMode = kCAFillModeForwards
		addAnimation(anim, forKey: "shadowOpacity")
		
	}
	
	func stopAnimation() {

		removeAnimationForKey("shadowOpacity")
		
	}
	
}