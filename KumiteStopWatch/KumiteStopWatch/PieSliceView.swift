//
//  PieSliceViewController.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 27/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

@IBDesignable public class PieSliceView: UIView {
	
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
			setNeedsDisplay()
		}
		
		get {
			return overlayLayer.fillScale
		}
	}
	
	private let animationStateMonitor: AnimationStateMonitor = AnimationStateMonitor()
	
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
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		conicalFillPieSliceProgressLayer.frame = bounds
		overlayLayer.frame = bounds
	}
	
	// This is test code for testing the basic animation, it doesn't really
	// belong here, but should probably be part of the contract with the view controller
	// This would also relies on the concept of the timeline, which will be implemented
	// later
	func start() {
		conicalFillPieSliceProgressLayer.animateProgressTo(1.0, withDurationOf:10, delegate: self)
	}
	
	override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		
		print("state = \(animationStateMonitor.currentState())")
		switch (animationStateMonitor.currentState()) {
		case .Stopped:
			start()
		case .Running:
			fallthrough
		case .Paused:
			animationStateMonitor.pauseOrResume(conicalFillPieSliceProgressLayer)
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