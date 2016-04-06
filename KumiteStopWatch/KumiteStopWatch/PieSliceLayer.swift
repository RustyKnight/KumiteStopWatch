//
//  PieSliceLayer.swift
//  ConicalFillTest
//
//	This is Swift version of the PieSliceLayer from pavanpodila/PieChart
//	https://github.com/pavanpodila/PieChart
//	http://blog.pixelingene.com/2012/02/animating-pie-slices-using-a-custom-calayer/
//

import UIKit
import KZCoreLibrary
import KZCoreUILibrary

public class PieSliceLayer: CALayer {

	public var startAngle: CGFloat = 0.0 {
		didSet {
			setNeedsDisplay()
		}
	}
	public var endAngle: CGFloat = 0.0 {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public var fillColor: UIColor? = UIColor.grayColor() {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public var lineWidth: CGFloat = 1.0 {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public var strokeColor: UIColor? = UIColor.blackColor() {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		needsDisplayOnBoundsChange = true
	}
	
	public override init() {
		super.init()
		needsDisplayOnBoundsChange = true
	}
	
	/*
		Override initWithLayer: to copy the properties into the new layer. This method gets called for each 
		frame of animation. Core Animation makes a copy of the presentationLayer for each frame of the animation. 
		By overriding this method we make sure our custom properties are correctly transferred to the copied-layer.	
	*/
	public override init(layer: AnyObject) {
		super.init(layer: layer)
		if let pieLayer = layer as? PieSliceLayer {
			startAngle = pieLayer.startAngle
			endAngle = pieLayer.endAngle
			
			fillColor = pieLayer.fillColor
			strokeColor = pieLayer.strokeColor
			lineWidth = pieLayer.lineWidth
		}
	}
	
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
		if event == "startAngle" || event == "endAngle" {
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
		if key == "startAngle" || key == "endAngle" {
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
		let radius = min(center.x, center.y)
		
		CGContextBeginPath(ctx)
		CGContextMoveToPoint(ctx, center.x, center.y)
		
		let p1 = CGPoint(
			x: center.x + radius * cos(startAngle),
			y: center.y + radius * sin(startAngle))
		CGContextAddLineToPoint(ctx, p1.x, p1.y)
		
		let clockwise = startAngle > endAngle ? 1 : 0
		CGContextAddArc(ctx, center.x, center.y, radius, startAngle, endAngle, Int32(clockwise))
		
		CGContextClosePath(ctx)
		
		CGContextSetFillColorWithColor(ctx, fillColor?.CGColor)
		CGContextSetStrokeColorWithColor(ctx, strokeColor?.CGColor)
		CGContextSetLineWidth(ctx, lineWidth)
		
		CGContextDrawPath(ctx, CGPathDrawingMode.FillStroke)
		
	}
}
