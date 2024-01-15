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
class TickLayer: CALayer, Animatable, Colorful {
	var colorBand: ColorBand? {
		didSet { setNeedsDisplay() }
	}
	
    @objc var fillColor: UIColor? = UIColor.red {
		didSet { setNeedsDisplay() }
	}
	
	var strokeColor: UIColor? = UIColor.yellow {
		didSet { setNeedsDisplay() }
	}

	/**
		Based on minimum dimension of the layers bounds, this represents
		the outer edge of the circle on which the tick will be placed,
		this allows you a measuer of control over where the tick is placed
	*/
	// NB: Would it be more accurate to use insets?
	var radiusScale: Float = 1.0 {
		didSet {
			setNeedsDisplay()
		}
	}
	
	/**
		Represents the angle that the tick should point at in radians
		This is a convience function for progress
	*/
    @objc var angle: CGFloat {
		set { progress = newValue.toFloat / 360.0.toFloat.toRadians }
		get { return (360.0.toFloat * progress).toRadians.toCGFloat }
	}
	
	@objc var progress: Float = 0.0 {
		didSet { setNeedsDisplay() }
	}
	
	var timeLineEvent: TimeLineEvent? {
		didSet { configureTimeLineEvent() }
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configure()
	}
	
	override init() {
		super.init()
		configure()
	}
	
	func configure() {
		needsDisplayOnBoundsChange = true
	}
	
	/*
	Override initWithLayer: to copy the properties into the new layer. This method gets called for each
	frame of animation. Core Animation makes a copy of the presentationLayer for each frame of the animation.
	By overriding this method we make sure our custom properties are correctly transferred to the copied-layer.
	*/
	override init(layer: Any) {
		super.init(layer: layer)
		if let layer = layer as? TickLayer {
			progress = layer.progress
			radiusScale = layer.radiusScale
			fillColor = layer.fillColor
			strokeColor = layer.strokeColor
			timeLineEvent = layer.timeLineEvent
		}
	}
	
	init(timeLineEvent: TimeLineEvent) {
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
			fillColor = UIColor.darkGray
			strokeColor = UIColor.lightGray
		}
	}
//	
//	override func animationForKey(key: String) -> CAAnimation? {
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
    override func action(forKey event: String) -> CAAction? {
        if event == #keyPath(TickLayer.progress) || event == #keyPath(TickLayer.angle) || event == #keyPath(TickLayer.fillColor) {
            return self.animation(forKey: event)
        }
        return super.action(forKey: event)
	}
	
	/*
	Finally we also need to override needsDisplayForKey: to tell Core Animation that changes to our
	startAngle and endAngle properties will require a redraw.
	*/
    override class func needsDisplay(forKey event: String) -> Bool {
        if event == #keyPath(TickLayer.progress) || event == #keyPath(TickLayer.angle) || event == #keyPath(TickLayer.fillColor) {
            return true
        }
        return false
	}
	
	/*
	Here we draw the slice just the way we did earlier. Instead of using UIBezierPath, we now go with the
	Core Graphics calls. Since the startAngle and endAngle properties are animatable and also marked for
	redraw, this layer will be rendered each frame of the animation. This will give us the desired animation
	when the slice changes its inscribed angle.
	*/
    override func draw(in ctx: CGContext) {
		let viewableBounds = bounds
		let center = CGPoint(x: CGRectGetWidth(viewableBounds) / 2, y: CGRectGetHeight(viewableBounds) / 2)
		let radius = (viewableBounds.minDimension() * radiusScale.toCGFloat) / 2
		
        ctx.saveGState()

		// The intention here is to rotate the context to the "start angle" position
        ctx.translateBy(x: center.x, y: center.y)
        ctx.rotate(by: -90.0.toRadians.toCGFloat)
		
		// But we need to reset the origin
        ctx.translateBy(x: -center.x, y: -center.y)

		// The point along the circle, this is where we need to point to
		let p1 = CGPoint(
			x: center.x + radius * cos(angle),
			y: center.y + radius * sin(angle))
		
		// Tranlsate the context so the "point to" point is at 0x0
        ctx.translateBy(x: p1.x, y: p1.y)
		// Rotate the context about this point, based on the angle
		// and offset for the tick.  At 0 degrees, the tick points up, towards
		// the "point to" point
        ctx.rotate(by: angle + 90.0.toRadians.toCGFloat)

		// Make the tick
        ctx.beginPath()
		
        ctx.move(to: .zero)
        ctx.addLine(to: CGPoint(x: 5.5, y: 11))
        ctx.addLine(to: CGPoint(x: -5.5, y: 11))
        ctx.closePath()
		
		if let fillColor = fillColor {
            ctx.setFillColor(fillColor.cgColor)
		}
		
		if let strokeColor = strokeColor {
            ctx.setStrokeColor(strokeColor.cgColor)
		}
        ctx.setLineWidth(1.0)
        ctx.drawPath(using: CGPathDrawingMode.fillStroke)
		
        ctx.restoreGState()
		
	}
	
	func startAnimation(withDurationOf duration:Double, withDelegate: CAAnimationDelegate?) {
        removeAnimation(forKey: #keyPath(TickLayer.progress))
        removeAnimation(forKey: #keyPath(TickLayer.fillColor))
		
		if let colorBand = colorBand {
			let keyFrameAnim = CAKeyframeAnimation(keyPath: #keyPath(TickLayer.fillColor))

			var colors: [UIColor] = []
			var locations: [Double] = []
			for i in stride(from: 0, to: 1.0, by: 0.01) {
				colors.append(colorBand.colorAt(i))
				locations.append(i)
			}
			
			keyFrameAnim.values = colors
            keyFrameAnim.keyTimes = locations.map { NSNumber(floatLiteral: $0) }
			keyFrameAnim.duration = duration
            add(keyFrameAnim, forKey: #keyPath(TickLayer.fillColor))
		}
		
		let anim = CABasicAnimation(keyPath: #keyPath(TickLayer.progress))
		anim.delegate = withDelegate
		
		anim.fromValue = 0
		anim.toValue = 1.0
		anim.duration = duration
        add(anim, forKey: #keyPath(TickLayer.progress))
	}
	
	func stopAnimation(andReset reset: Bool = false) {
        removeAnimation(forKey: #keyPath(TickLayer.progress))
        removeAnimation(forKey: #keyPath(TickLayer.fillColor))
		if (reset) {
			progress = 0.0
		}
	}
	
}
