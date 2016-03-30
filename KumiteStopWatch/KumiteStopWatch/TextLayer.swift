//
//  TextLayer.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 30/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreLibrary
import KZCoreUILibrary

public class TextLayer: CALayer {
	
	public var progress: CGFloat = 0
	var animationDuration: Double = 0
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		needsDisplayOnBoundsChange = true
	}
	
	public override init() {
		super.init()
		needsDisplayOnBoundsChange = true
	}
	
	public override init(layer: AnyObject) {
		super.init(layer: layer)
		if let layer = layer as? TextLayer {
			progress = layer.progress
			animationDuration = layer.animationDuration
			needsDisplayOnBoundsChange = true
		}
	}
	
	public override func animationForKey(key: String) -> CAAnimation? {
		let anim: CABasicAnimation = CABasicAnimation(keyPath: key)
		anim.fromValue = presentationLayer()?.valueForKey(key)
		anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		anim.duration = 0.5
		
		return anim
	}
	
	/*
	Override actionForKey: and return a CAAnimation that prepares the animation for that property.
	In our case, we will return an animation for the startAngle and endAngle properties.
	*/
	public override func actionForKey(event: String) -> CAAction? {
		var action: CAAction?
		if event == "progress" || event == "animationDuration" {
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
		if key == "progress" || key == "animationDuration" {
			needsDisplay = true
		} else {
			needsDisplay = super.needsDisplayForKey(key)
		}
		return needsDisplay
	}

	func formatDurationAt(progress: Double) -> String {
		
		let time = animationDuration * progress
		
		let date = NSDate(timeIntervalSince1970: time)
		let format = NSDateFormatter()
		format.dateFormat = "mm:ss.SS"
		format.timeZone = NSTimeZone(forSecondsFromGMT: 0)
		
		return format.stringFromDate(date)
		
	}

	public override func drawInContext(ctx: CGContext) {
		let radius = bounds.minDimension() / 2.0.toCGFloat

		CGContextSaveGState(ctx)
		
		CGContextSetShouldAntialias(ctx, true)
		CGContextSetShouldSmoothFonts(ctx, true)
		CGContextSetShouldSubpixelPositionFonts(ctx, true)
		CGContextSetShouldSubpixelQuantizeFonts(ctx, true)

		CGContextTranslateCTM(ctx,
		                      0, //CGRectGetWidth(bounds),
		                      CGRectGetHeight(bounds));
		CGContextScaleCTM(ctx, 1.0, -1.0);
		
		let textValue = formatDurationAt(progress.toDouble)
		
		let aFont = UIFont(name: "Helvetica Neue", size: radius / 4.0)
		// create a dictionary of attributes to be applied to the string
		let attr:CFDictionaryRef = [NSFontAttributeName:aFont!,NSForegroundColorAttributeName:UIColor.whiteColor()]
		// create the attributed string
		let text = CFAttributedStringCreate(nil, textValue, attr)
		// create the line of text
		let line = CTLineCreateWithAttributedString(text)
		// retrieve the bounds of the text
		let lineBounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
		// set the line width to stroke the text with
		CGContextSetLineWidth(ctx, 1.5)
		// set the drawing mode to stroke
		CGContextSetTextDrawingMode(ctx, CGTextDrawingMode.Fill)
		// Set text position and draw the line into the graphics context, text length and height is adjusted for
		let xn = bounds.centerOf().x - lineBounds.width / 2.0
		let yn = bounds.centerOf().y - lineBounds.midY
		CGContextSetTextPosition(ctx, xn, yn)
		// the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
		// draw the line of text
		CTLineDraw(line, ctx)
		
		CGContextRestoreGState(ctx)
	}
	
	public func animateProgressTo(progress: Double, withDurationOf duration:Double) {
		removeAnimationForKey("progress")
		
		let anim = CABasicAnimation(keyPath: "progress")
		anim.delegate = delegate
		anim.fromValue = 0
		anim.toValue = 1.0
		anim.duration = duration
		addAnimation(anim, forKey: "progress")
		
		self.progress = 1.0
		self.animationDuration = duration
	}
	
}
