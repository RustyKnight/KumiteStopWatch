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

class PieSliceLayer: CALayer {

	@objc var startAngle: CGFloat = 0.0 {
		didSet { setNeedsDisplay() }
	}
    @objc var endAngle: CGFloat = 0.0 {
		didSet { setNeedsDisplay() }
	}
	
	var fillColor: UIColor? = UIColor.gray {
		didSet {
			setNeedsDisplay()
		}
	}
	
	var lineWidth: CGFloat = 1.0 {
		didSet {
			setNeedsDisplay()
		}
	}
	
	var strokeColor: UIColor? = UIColor.black {
		didSet {
			setNeedsDisplay()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		needsDisplayOnBoundsChange = true
	}
	
	override init() {
		super.init()
		needsDisplayOnBoundsChange = true
	}
	
	/*
		Override initWithLayer: to copy the properties into the new layer. This method gets called for each 
		frame of animation. Core Animation makes a copy of the presentationLayer for each frame of the animation. 
		By overriding this method we make sure our custom properties are correctly transferred to the copied-layer.	
	*/
	override init(layer: Any) {
		super.init(layer: layer)
		if let pieLayer = layer as? PieSliceLayer {
			startAngle = pieLayer.startAngle
			endAngle = pieLayer.endAngle
			
			fillColor = pieLayer.fillColor
			strokeColor = pieLayer.strokeColor
			lineWidth = pieLayer.lineWidth
		}
	}
	
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
    
    override func action(forKey key: String) -> CAAction? {
        if key == #keyPath(PieSliceLayer.startAngle) || key == #keyPath(PieSliceLayer.endAngle) {
            return self.animation(forKey: key)
        }
		return super.action(forKey: key)
	}
	
	/*
		Finally we also need to override needsDisplayForKey: to tell Core Animation that changes to our 
		startAngle and endAngle properties will require a redraw.	
	*/
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(PieSliceLayer.startAngle) || key == #keyPath(PieSliceLayer.endAngle) {
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
		let radius = min(center.x, center.y)
		
        ctx.beginPath()
        ctx.move(to: center)
		
		let p1 = CGPoint(
			x: center.x + radius * cos(startAngle),
			y: center.y + radius * sin(startAngle)
        )
        ctx.addLine(to: p1)
		
		let clockwise = startAngle > endAngle ? true : false
        ctx.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        ctx.closePath()
        
        if let fillColor {
            ctx.setFillColor(fillColor.cgColor)
        }
        if let strokeColor {
            ctx.setStrokeColor(strokeColor.cgColor)
        }
        ctx.setLineWidth(lineWidth)
        ctx.drawPath(using: .fillStroke)
	}
}
