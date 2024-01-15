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

class TextLayer: ProgressLayer, Animatable, Colorful {
	var colorBand: ColorBand? {
		didSet { setNeedsDisplay() }
	}
	var animationDuration: Double = 0
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		needsDisplayOnBoundsChange = true
	}
	
	override init() {
		super.init()
		needsDisplayOnBoundsChange = true
	}
	
	override init(layer: Any) {
		super.init(layer: layer)
		if let layer = layer as? TextLayer {
			animationDuration = layer.animationDuration
			colorBand = layer.colorBand
			needsDisplayOnBoundsChange = true
		}
	}
    
    override class func needsDisplay(forKey key: String) -> Bool {
		var needsDisplay = false
		if key == "progress" {
			needsDisplay = true
		} else {
            needsDisplay = super.needsDisplay(forKey: key)
		}
		return needsDisplay
	}
	
	func formatDurationAt(progress: Double) -> String {
		
		let time = animationDuration * progress
		
		let date = Date(timeIntervalSince1970: time)
		let format = DateFormatter()
		format.dateFormat = "mm:ss.SS"
        format.timeZone = TimeZone(secondsFromGMT: 0)
		
        return format.string(from: date)
		
	}
    
    override func draw(in ctx: CGContext) {
		let radius = frame.minDimension() / 2.0.toCGFloat

        ctx.saveGState()
		
        ctx.setShouldAntialias(true)
        ctx.setShouldSmoothFonts(true)
        ctx.setShouldSubpixelPositionFonts(true)
        ctx.setShouldSubpixelQuantizeFonts(true)

        ctx.translateBy(
            x: 0, //CGRectGetWidth(bounds),
            y: CGRectGetHeight(bounds)
        )
        ctx.scaleBy(x: 1.0, y: -1.0)
		
        let textValue = formatDurationAt(progress: progress.toDouble)
		
        var foregroundColor = UIColor.white
		if let colorBand = colorBand {
			foregroundColor = colorBand.colorAt(progress.toDouble)
		}
        
        let font = CTFontCreateWithName("Helvetica Neue" as CFString, radius / 4.0, nil)
        let attributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: foregroundColor
        ]
        let attributedString = NSAttributedString(
            string: textValue,
            attributes: attributes
        )
        
        let line = CTLineCreateWithAttributedString(attributedString)
        //let stringRect = CTLineGetImageBounds(line, ctx)
        let lineBounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useOpticalBounds)
        let textPosition = CGPoint(
            x: bounds.centerOf().x - lineBounds.width / 2.0,
            y: bounds.centerOf().y - lineBounds.midY
        )

        ctx.textPosition = textPosition
        
        ctx.setLineWidth(1.5)
        ctx.setTextDrawingMode(.fill)
        CTLineDraw(line, ctx)

        
//		// create a dictionary of attributes to be applied to the string
//        let attr: CFDictionary = [
//            NSFontAttributeName: aFont!,
//            NSForegroundColorAttributeName: foregroundColor
//        ]
//		// create the attributed string
//		let text = CFAttributedStringCreate(nil, textValue, attr)
//		// create the line of text
//		let line = CTLineCreateWithAttributedString(text)
//		// retrieve the bounds of the text
//		let lineBounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
//		// set the line width to stroke the text with
//        ctx.setLineWidth(1.5)
//		// set the drawing mode to stroke
//        ctx.setTextDrawingMode(.fill)
//		// Set text position and draw the line into the graphics context, text length and height is adjusted for
//		let xn = bounds.centerOf().x - lineBounds.width / 2.0
//		let yn = bounds.centerOf().y - lineBounds.midY
//        ctx.textPosition = CGPoint(x: xn, y: yn)
//		// the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
//		// draw the line of text
//		CTLineDraw(line, ctx)
		
        ctx.restoreGState()
	}
	
	func startAnimation(withDurationOf duration:Double, withDelegate: CAAnimationDelegate?) {
        removeAnimation(forKey: "progress")
		
		let anim = CABasicAnimation(keyPath: "progress")
		anim.delegate = withDelegate
		anim.fromValue = 0
		anim.toValue = 1.0
		anim.duration = duration
        add(anim, forKey: "progress")
		
		self.progress = 1.0
		self.animationDuration = duration
	}
	
	func stopAnimation(andReset reset: Bool) {
        removeAnimation(forKey: "progress")
		if reset {
			self.progress = 0.0
			setNeedsDisplay()
		}
	}
	
}
