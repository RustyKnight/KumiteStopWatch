//
//  PieSliceViewController.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 27/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

@IBDesignable public class TimeLineProgressView: UIView {
	
	private let conicalFillPieSliceProgressLayer: ConicalFillPieSliceProgressLayer = ConicalFillPieSliceProgressLayer()
	private let overlayLayer: OverlayLayer = OverlayLayer()
	
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
	
	@IBInspectable public var colors: [UIColor] {
		set(newValue) {
			conicalFillPieSliceProgressLayer.colors = newValue
			setNeedsDisplay()
		}
		
		get {
			return conicalFillPieSliceProgressLayer.colors
		}
	}
	
	@IBInspectable public var locations: [Double] {
		set(newValue) {
			conicalFillPieSliceProgressLayer.locations = newValue
			setNeedsDisplay()
		}
		
		get {
			return conicalFillPieSliceProgressLayer.locations
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
	
	private let animationStateMonitor: AnimationStateMonitor = AnimationStateMonitor()

	private let textLayer: TextLayer = TextLayer()
	private let tickLayer: TickLayer = TickLayer()
	// This needs to be made into a list, but right now
	// this is just a test
	private var timeLineTickLayers: [TickLayer] = []
	
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
		
		tickLayer.progress = 0.0

		overlayLayer.fillColor = UIColor.blackColor().CGColor
		overlayLayer.strokeColor = UIColor.darkGrayColor().CGColor
		overlayLayer.shadowColor = UIColor.yellowColor().CGColor
		overlayLayer.shadowOffset = CGSize(width: 0, height: 0)
		overlayLayer.shadowOpacity = 0.5
		
		progressLineWidth = 1
		progressStrokeColor = UIColor.whiteColor()
		
		let colors = [UIColor.greenColor(), UIColor.yellowColor(), UIColor.redColor()]
		let locations = [0.0, 0.75, 1.0]
		conicalFillPieSliceProgressLayer.colors = colors
		conicalFillPieSliceProgressLayer.locations = locations
		
		tickLayer.fillColors = colors
		tickLayer.fillLocations = locations
		
		conicalFillPieSliceProgressLayer.frame = bounds
		overlayLayer.frame = bounds
		layer.addSublayer(conicalFillPieSliceProgressLayer)
		layer.addSublayer(overlayLayer)

		layer.addSublayer(tickLayer)
		
		timeLine = TimeLineBuilder()
			.add(location: 0.75, color: UIColor.yellowColor(), alerts: TimeLineAlert.None)
			.build()
		updateTimeLine()
		
		textLayer.bounds = frame
		layer.addSublayer(textLayer)
	}
	
	func updateTimeLine() {
		for tickLayer in timeLineTickLayers {
			tickLayer.removeFromSuperlayer()
		}
		timeLineTickLayers.removeAll()
		if let timeLine = timeLine {
			for evt in timeLine.events {
				let tick = TickLayer(timeLineEvent: evt)
				tick.radiusScale = tickLayer.radiusScale
				timeLineTickLayers.append(tick)
				tick.frame = bounds
				layer.addSublayer(tick)
			}
		}
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
	
	// This is test code for testing the basic animation, it doesn't really
	// belong here, but should probably be part of the contract with the view controller
	// This would also relies on the concept of the timeline, which will be implemented
	// later
	func start() {
		let duration = 2.0 * 60.0
		conicalFillPieSliceProgressLayer.animateProgressTo(1.0, withDurationOf:duration, delegate: self)
		tickLayer.animateProgressTo(1.0, withDurationOf: duration)
		textLayer.animateProgressTo(1.0, withDurationOf: duration)
	}
	
	override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		
		print("state = \(animationStateMonitor.currentState())")
		switch (animationStateMonitor.currentState()) {
		case .Stopped:
			start()
		case .Running:
			conicalFillPieSliceProgressLayer.pauseAnimation()
			tickLayer.pauseAnimation()
			textLayer.pauseAnimation()
			animationStateMonitor.paused()
		case .Paused:
			conicalFillPieSliceProgressLayer.resumeAnimation()
			tickLayer.resumeAnimation()
			textLayer.resumeAnimation()
			animationStateMonitor.running()
		}
	}
	
	public override func animationDidStart(anim: CAAnimation) {
		animationStateMonitor.started()
		print("Started; state = \(animationStateMonitor.currentState())")
	}
	
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		animationStateMonitor.stopped()
		print("Stopped; state = \(animationStateMonitor.currentState())")
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
	}
	
	override func layoutSublayers() {
		super.layoutSublayers()
		let diameter = bounds.minDimension()
		let scaledSize = diameter * fillScale.toCGFloat
		let centerX = (bounds.width - scaledSize) / 2
		let centerY = (bounds.height - scaledSize) / 2
		
		path = UIBezierPath(ovalInRect: CGRect(x: centerX, y: centerY, width: scaledSize, height: scaledSize)).CGPath
	}
	
}