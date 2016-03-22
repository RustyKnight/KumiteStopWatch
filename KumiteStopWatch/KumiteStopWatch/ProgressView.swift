//
//  ProgressView.swift
//  StopWatchTest02
//
//  Created by Shane Whitehead on 14/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

/**
	This is the "base" view ontop of which the cut out layer and the
	pie slice layer are placed
*/
@IBDesignable
public class ProgressView: UIView {
	
	let progressLayer: PieSliceProgressLayer = PieSliceProgressLayer()
	let cutoutLayer: OverlayCutoutLayer = OverlayCutoutLayer()
	
	@IBInspectable public override var backgroundColor: UIColor? {
		didSet {
			if let backgroundColor = backgroundColor {
				cutoutLayer.fillColor = backgroundColor.CGColor
				cutoutLayer.strokeColor = backgroundColor.CGColor
			} else {
				cutoutLayer.fillColor = nil
				cutoutLayer.strokeColor = nil
			}
		}
	}

	@IBInspectable public var trackColor: UIColor? {
		set(newValue) {
				super.backgroundColor = newValue
		}
		
		get {
			return super.backgroundColor
		}
	}
	
	@IBInspectable public var contentInsets: UIEdgeInsets = UIEdgeInsetsZero {
		didSet {
			cutoutLayer.contentInsets = contentInsets
			progressLayer.contentInsets = contentInsets
		}
	}
	
	@IBInspectable public var shadowColor: UIColor? {
		set(newValue) {
			if let shadowColor = newValue {
				cutoutLayer.shadowColor = shadowColor.CGColor
			} else {
				cutoutLayer.shadowColor = nil
			}
		}
		
		get {
			var color: UIColor? = nil
			if let theColor = cutoutLayer.shadowColor {
				color = UIColor(CGColor: theColor)
			}
			return color
		}
	}
	
	@IBInspectable public var shadowOpacity: Float {
		set(newValue) {
			cutoutLayer.shadowOpacity = newValue
		}
		
		get {
			return cutoutLayer.shadowOpacity
		}
	}
	
	@IBInspectable public var strokeColor: UIColor? {
		set(newValue) {
			if let strokeColor = newValue {
				cutoutLayer.strokeColor = strokeColor.CGColor
				cutoutLayer.lineWidth = 1
			} else {
				cutoutLayer.strokeColor = nil
				cutoutLayer.lineWidth = 0
			}
			setNeedsDisplay()
		}
		
		get {
			var color: UIColor? = nil
			if let theColor = cutoutLayer.strokeColor {
				color = UIColor(CGColor: theColor)
			}
			return color
		}
	}
	
	@IBInspectable public var progressLineWidth: CGFloat {
		set(newValue) {
			progressLayer.lineWidth = newValue
			setNeedsDisplay()
		}
		
		get {
			return progressLayer.lineWidth
		}
	}
	
	@IBInspectable public var progressStrokeColor: UIColor? {
		set(newValue) {
			progressLayer.strokeColor = newValue
			setNeedsDisplay()
		}
		
		get {
			return progressLayer.strokeColor
		}
	}
	
	@IBInspectable public var cutoutThickness: CGFloat {
		set(newValue) {
			cutoutLayer.thickness = newValue
		}
		
		get {
			return cutoutLayer.thickness
		}
	}
	
	@IBInspectable public var colors: [CGColor]! {
		set(newValue) {
			progressLayer.colors = newValue
		}
		
		get {
			return progressLayer.colors as! [CGColor]!
		}
	}

	@IBInspectable public var locations: [CGFloat]! {
		set(newValue) {
			progressLayer.locations = newValue
		}
		
		get {
			return progressLayer.locations as! [CGFloat]!
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
		contentInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
		backgroundColor = UIColor.blackColor()
		progressLayer.colors = [
			UIColor.greenColor().CGColor,
			UIColor.yellowColor().CGColor,
			UIColor.redColor().CGColor]
		progressLayer.locations = [
			0.0,
			0.75,
			1.0]
		
		backgroundColor = UIColor.darkGrayColor()
		
		// Cutout based properties
		cutoutThickness = 25.0
		strokeColor = UIColor.yellowColor()
		shadowColor = UIColor.darkGrayColor()
		shadowOpacity = 0.5
		
		progressLayer.frame = bounds
		cutoutLayer.frame = bounds
		layer.addSublayer(progressLayer)
		layer.addSublayer(cutoutLayer)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		progressLayer.frame = bounds
		cutoutLayer.frame = bounds
	}
	
	// This is test code for testing the basic animation, it doesn't really
	// belong here, but should probably be part of the contract with the view controller
	// This would also rely on the concept of the timeline, which will be implemented
	// later
//	func start() {
//		progressLayer.animateProgressTo(1.0, withDurationOf:2.0 * 60.0, delegate: self)
//	}
//	
//	override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//		super.touchesBegan(touches, withEvent: event)
//
//		print("state = \(animationStateMonitor.currentState())")
//		switch (animationStateMonitor.currentState()) {
//		case .Stopped:
//			start()
//		case .Running:
//			fallthrough
//		case .Paused:
//			animationStateMonitor.pauseOrResume(progressLayer)
//		}
//	}
//	
//	public override func animationDidStart(anim: CAAnimation) {
//		animationStateMonitor.started()
//		print("Started; state = \(animationStateMonitor.currentState())")
//	}
//	
//	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//		animationStateMonitor.stopped()
//		print("Stopped; state = \(animationStateMonitor.currentState())")
//	}

}
