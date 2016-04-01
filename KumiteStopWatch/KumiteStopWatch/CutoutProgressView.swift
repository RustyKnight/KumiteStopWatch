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
public class CutoutProgressView: UIView {
	
	let progressLayer: ConicalFillPieSliceProgressLayer = ConicalFillPieSliceProgressLayer()
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
	
	private let animationManager: AnimationManager = AnimationManager()
	
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
		
		animationManager.animatables.append(progressLayer)
		
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
	
	override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)

		switch (animationManager.currentState()) {
		case .Stopped:
			animationManager.start(withDurationOf: 2.0 * 6.0, withDelegate: self)
		case .Running:
			animationManager.pause()
		case .Paused:
			animationManager.resume()
		}
	}
	
	public override func animationDidStart(anim: CAAnimation) {
		print("Started; state = \(animationManager.currentState())")
	}
	
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		print("Stopped; state = \(animationManager.currentState())")
	}

}
