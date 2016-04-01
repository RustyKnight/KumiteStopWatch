//
//  TickLayer.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 29/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreUILibrary

/**
	The intention of the TickLayer is to provide a simple shape which can point to some
	point on a circle
*/
public class TickLayer: CALayer, Animatable, Colorful {
	
	public var colorBand: ColorBand? {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public var fillColor: UIColor? = UIColor.redColor() {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public var strokeColor: UIColor? = UIColor.yellowColor() {
		didSet {
			setNeedsDisplay()
		}
	}

	/**
		Based on minimum dimension of the layers bounds, this represents
		the outer edge of the circle on which the tick will be placed,
		this allows you a measuer of control over where the tick is placed
	*/
	// NB: Would it be more accurate to use insets?
	public var radiusScale: Float = 1.0 {
		didSet {
			setNeedsDisplay()
		}
	}
	
	/**
		Represents the angle that the tick should point at in radians
		This is a convience function for progress
	*/
	public var angle: CGFloat {
		set(newValue) {
			progress = angle.toFloat / 360.0.toFloat.toRadians
		}
		
		get {
			return (360.0.toFloat * progress).toRadians.toCGFloat
		}
	}
	
	public var progress: Float = 0.0 {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public var timeLineEvent: TimeLineEvent? {
		didSet {
			configureTimeLineEvent()
		}
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configure()
	}
	
	public override init() {
		super.init()
		configure()
	}
	
	func configure() {
	}
	
	/*
	Override initWithLayer: to copy the properties into the new layer. This method gets called for each
	frame of animation. Core Animation makes a copy of the presentationLayer for each frame of the animation.
	By overriding this method we make sure our custom properties are correctly transferred to the copied-layer.
	*/
	public override init(layer: AnyObject) {
		super.init(layer: layer)
		if let layer = layer as? TickLayer {
			progress = layer.progress
			radiusScale = layer.radiusScale
			fillColor = layer.fillColor
			strokeColor = layer.strokeColor
			timeLineEvent = layer.timeLineEvent
		}
	}
	
	public init(timeLineEvent: TimeLineEvent) {
		super.init()
		self.timeLineEvent = timeLineEvent
		configureTimeLineEvent();
	}
	
	func configureTimeLineEvent() {
		if let timeLineEvent = timeLineEvent {
			progress = timeLineEvent.location.toFloat
			fillColor = timeLineEvent.color
			strokeColor = timeLineEvent.color.darken(by: 0.5)
		} else {
			progress = 0.0
			fillColor = UIColor.darkGrayColor()
			strokeColor = UIColor.lightGrayColor()
		}
	}
//	
//	public override func animationForKey(key: String) -> CAAnimation? {
//		let anim: CABasicAnimation = CABasicAnimation(keyPath: key)
//		anim.fromValue = presentationLayer()?.valueForKey(key)
//		anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//		anim.duration = 0.5
//		
//		return anim
//	}
	
	/*
	Override actionForKey: and return a CAAnimation that prepares the animation for that property.
	In our case, we will return an animation for the startAngle and endAngle properties.
	*/
	public override func actionForKey(event: String) -> CAAction? {
		var action: CAAction?
		if event == "progress" || event == "angle" || event == "fillColor" || event == "fillEffect" {
			action = self.animationForKey(event)
		} else {
			action = super.actionForKey(event)
		}
		return action
	}
	
	/*
	Finally we also need to override needsDisplayForKey: to tell Core Animation that changes to our
	startAngle and endAngle properties will require a redraw.
	*/
	public override class func needsDisplayForKey(key: String) -> Bool {
		var needsDisplay = false
		if key == "progress" || key == "angle" || key == "fillColor" || key == "fillEffect" {
			needsDisplay = true
		} else {
			needsDisplay = super.needsDisplayForKey(key)
		}
		return needsDisplay
	}
	
	/*
	Here we draw the slice just the way we did earlier. Instead of using UIBezierPath, we now go with the
	Core Graphics calls. Since the startAngle and endAngle properties are animatable and also marked for
	redraw, this layer will be rendered each frame of the animation. This will give us the desired animation
	when the slice changes its inscribed angle.
	*/
	public override func drawInContext(ctx: CGContext) {
		let viewableBounds = bounds
		let center = CGPoint(x: CGRectGetWidth(viewableBounds) / 2, y: CGRectGetHeight(viewableBounds) / 2)
		let radius = (viewableBounds.minDimension() * radiusScale.toCGFloat) / 2
		
		CGContextSaveGState(ctx)

		// The intention here is to rotate the context to the "start angle" position
		CGContextTranslateCTM(ctx, center.x, center.y)
		CGContextRotateCTM(ctx, -90.0.toRadians.toCGFloat)

//		CGContextBeginPath(ctx)
//		
//		CGContextAddEllipseInRect(ctx, CGRect(x: -radius, y: -radius, width: radius * 2.0, height: radius * 2.0))
//		
//		CGContextSetStrokeColorWithColor(ctx, UIColor.redColor().CGColor)
//		CGContextSetLineWidth(ctx, 1.0)
//		CGContextDrawPath(ctx, CGPathDrawingMode.Stroke)
		
		// But we need to reset the origin
		CGContextTranslateCTM(ctx, -center.x, -center.y)
		
		// Save the next state
//		CGContextSaveGState(ctx)

		// The point along the circle, this is where we need to point to
		let p1 = CGPoint(
			x: center.x + radius * cos(angle),
			y: center.y + radius * sin(angle))
		
		// Tranlsate the context so the "point to" point is at 0x0
		CGContextTranslateCTM(ctx, p1.x, p1.y)
		// Rotate the context about this point, based on the angle
		// and offset for the tick.  At 0 degrees, the tick points up, towards
		// the "point to" point
		CGContextRotateCTM(ctx, angle + 90.0.toRadians.toCGFloat)

		// Make the tick
		CGContextBeginPath(ctx)
		
		CGContextMoveToPoint(ctx, 0, 0)
		CGContextAddLineToPoint(ctx, 5.5, 11)
		CGContextAddLineToPoint(ctx, -5.5, 11)
		CGContextClosePath(ctx)
		
		if let fillColor = fillColor {
			CGContextSetFillColorWithColor(ctx, fillColor.CGColor)
		}
		
		if let strokeColor = strokeColor {
			CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor)
		}
		CGContextSetLineWidth(ctx, 1.0)
		CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
		
//		CGContextRestoreGState(ctx)
		CGContextRestoreGState(ctx)
		
	}
	
	public func startAnimation(withDurationOf duration:Double, withDelegate: AnyObject?) {
		removeAnimationForKey("progress")
		removeAnimationForKey("fillEffect")
		
		if let colorBand = colorBand {
			let keyFrameAnim = CAKeyframeAnimation(keyPath: "fillColor")

			var colors: [UIColor] = []
			var locations: [Double] = []
			for i in 0.0.stride(to: 1.0, by: 0.01) {
				colors.append(colorBand.colorAt(i))
				locations.append(i)
			}
			
//			for colorBandEntry in colorBand.entries {
//				colors.append(colorBandEntry.color)
//				locations.append(colorBandEntry.location)
//			}
			
			keyFrameAnim.values = colors
			keyFrameAnim.keyTimes = locations
			keyFrameAnim.duration = duration
			addAnimation(keyFrameAnim, forKey: "fillEffect")
		}
		
		let anim = CABasicAnimation(keyPath: "progress")
		anim.delegate = withDelegate
		
		anim.fromValue = 0
		anim.toValue = 1.0
		anim.duration = duration
		addAnimation(anim, forKey: "progress")
	}
	
	public func stopAnimation(andReset reset: Bool = false) {
		removeAnimationForKey("progress")
		removeAnimationForKey("fillEffect")
		if (reset) {
			progress = 0.0
		}
	}
	
}
