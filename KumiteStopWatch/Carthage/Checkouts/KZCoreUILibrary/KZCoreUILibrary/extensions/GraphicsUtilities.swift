//
//  GraphicsUtilities.swift
//  KZCoreUILibrary
//
//  Created by Shane Whitehead on 25/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

// I'm wondering if this is actually a good idea...
// This is going to look weird, but I've done it
// deliberatly to show case the intention
//
// So I have these two methods, they take parameters
// and generate a result (UIImage), there's no
// good reason I can think of for having them included
// in a standalone class, apart from changing the internal
// implementation.
//
// I kind of like to "contain" the functions to make it easer
// to use (I like ImageUtilities.xxx of KZxxx but that's me)
//
// A struct wouldn't give me the flexibility I want and I though
// about using UIImage as the extension point, but does that make
// sense, they return a UIImage, but they aren't extending it's
// functionality in any real manner
//
// The class/extension mechanism provides me with a key starting
// point for "image/graphics related" utilities or effects
// and would make it easier to lookup via autocomplete, but is that
// a compeling enough reason?
public class KZGraphicsUtilities {
	
}

public extension KZGraphicsUtilities {
	/**
	This creates a conical fill effect of the specified size with the specified colors spread between the specified
	locations
	
	The intention is to return an image which is completely filled
	*/
	public class func createConicalGraidentOf(size size: CGSize, withColors colors: [UIColor], withLocations locations: [Double]) -> UIImage {
		
		var currentAngle: CGFloat = 0.0
		
		// workaround
		var limit: CGFloat = 1.0 // 32bit
		if sizeof(limit.dynamicType) == 8 {
			limit = 1.001 // 64bit
		}
		
		let arcRadius: CGFloat = size.maxDimension()
		let arcPoint: CGPoint = size.centerOf()
		
		let width = size.width
		let height = size.height
		UIGraphicsBeginImageContextWithOptions(
			CGSize(width: width, height: height),
			false,
			0.0)
		// Need to flip it horizontally
		let ctx = UIGraphicsGetCurrentContext()
		CGContextTranslateCTM(ctx,
		                      width,
		                      height);
		CGContextScaleCTM(ctx, -1.0, -1.0);
		CGContextSetAllowsAntialiasing(ctx, true)
		CGContextSetShouldAntialias(ctx, true)
		
		let band = ColorBand(colors: colors, locations: locations)
		for i in 0.0.stride(to: Double(limit), by: 0.001) {
			
			let arcStartAngle: CGFloat = -90.0.toRadians.toCGFloat
			let arcEndAngle: CGFloat = CGFloat(i) * 2.0 * CGFloat(M_PI) - arcStartAngle
			
			if currentAngle == 0.0 {
				currentAngle = arcStartAngle
			} else {
				currentAngle = arcEndAngle - 0.1
			}
			
			let fillColor: UIColor = band.colorAt(i)
			
			let path = UIBezierPath()
			path.moveToPoint(arcPoint)
			let pointTo = CGPoint(
				x: (arcPoint.x) + (arcRadius * cos(currentAngle)),
				y: (arcPoint.y) + (arcRadius * sin(currentAngle)))
			path.addLineToPoint(pointTo)
			
			// This use to draw a circle, now I just want to paint
			// beyond the bounds of the available viewable area
			// this can then be masked or what ever...
			//			let arc: UIBezierPath = UIBezierPath(arcCenter: arcPoint,
			//			                                     radius: arcRadius,
			//			                                     startAngle: currentAngle,
			//			                                     endAngle: arcEndAngle,
			//			                                     clockwise: true)
			//			path.appendPath(arc)
			path.addLineToPoint(CGPoint(
				x: (arcPoint.x) + (arcRadius * cos(arcEndAngle)),
				y: (arcPoint.y) + (arcRadius * sin(arcEndAngle))))
			path.addLineToPoint(arcPoint)
			
			fillColor.setFill()
			
			UIColor.grayColor().setStroke()
			path.lineCapStyle = CGLineCap.Round
			path.fill()
		}
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
		
	}
	
}

public extension KZGraphicsUtilities {
	
	public class func createRadialGraidentOf(size size: CGSize, withColors colors: [UIColor], withLocations locations: [Double]) -> UIImage {
		
		let width = size.width
		let height = size.height
		
		UIGraphicsBeginImageContextWithOptions(
			CGSize(width: width, height: height),
			false,
			0.0)
		// Need to flip it horizontally
		let ctx = UIGraphicsGetCurrentContext()
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		
		let floatLocations = locations.map {
			$0.toCGFloat
		}
		let cgColors = colors.map {
			$0.CGColor
		}
		let gradient = CGGradientCreateWithColors(colorSpace, cgColors, floatLocations)
		
		let center = size.centerOf()
		let radius = size.minDimension() / 2.0
		
		CGContextDrawRadialGradient(
			ctx,
			gradient,
			center,
			0,
			center,
			radius,
			CGGradientDrawingOptions.DrawsAfterEndLocation)
		
		
		CGContextSetAllowsAntialiasing(ctx, true)
		CGContextSetShouldAntialias(ctx, true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
	
}

public extension UIImage {
	
	public func maskWith(maskImage: UIImage) -> UIImage? {
		var cgMask = maskImage.CGImage
		cgMask = CGImageMaskCreate(
			CGImageGetWidth(cgMask),
			CGImageGetHeight(cgMask),
			CGImageGetBitsPerComponent(cgMask),
			CGImageGetBitsPerPixel(cgMask),
			CGImageGetBytesPerRow(cgMask),
			CGImageGetDataProvider(cgMask),
			nil,
			true)
		
		let cgMasked = CGImageCreateWithMask(CGImage, cgMask)
		var imgMasked: UIImage?
		if let cgMasked = cgMasked {
			imgMasked = UIImage(CGImage: cgMasked)
		}
		return imgMasked
		
	}
	
}

public extension UIEdgeInsets {
	
	func verticalInsets() -> CGFloat {
		return top + bottom
	}
	
	func horizontalInsets() -> CGFloat {
		return left + right
	}
	
}

func scaleFactorFrom(original: CGFloat, to: CGFloat) -> CGFloat {
	return to / original
}

public extension CGRect {
	func withInsets(insets: UIEdgeInsets) -> CGRect {
		return CGRect(x: CGRectGetMinX(self) + insets.left,
		              y: CGRectGetMinY(self) + insets.top,
		              width: CGRectGetWidth(self) - (insets.right + insets.left),
		              height: CGRectGetHeight(self) - (insets.bottom + insets.top))
	}
	
	func maxDimension() -> CGFloat {
		return max(CGRectGetWidth(self), CGRectGetHeight(self))
	}
	
	func minDimension() -> CGFloat {
		return min(CGRectGetWidth(self), CGRectGetHeight(self))
	}
	
	func centerOf() -> CGPoint {
		return CGPoint(
			x: CGRectGetMinX(self) + (CGRectGetWidth(self) / 2),
			y: CGRectGetMinY(self) + (CGRectGetHeight(self) / 2))
	}
	
}

public extension CGSize {
	func maxDimension() -> CGFloat {
		return max(width, height)
	}
	
	func minDimension() -> CGFloat {
		return min(width, height)
	}
	
	func centerOf() -> CGPoint {
		return CGPoint(x: width / 2, y: height / 2)
	}
	
	func scaleToFit(target: CGSize) -> CGSize {
		return scaleBy(min(
			scaleFactorFrom(width, to: target.width),
			scaleFactorFrom(height, to: target.height)))
	}
	
	func scaleToFill(target: CGSize) -> CGSize {
		return scaleBy(max(
			scaleFactorFrom(width, to: target.width),
			scaleFactorFrom(height, to: target.height)))
	}
	
	func scaleBy(factor: CGFloat) -> CGSize {
		return CGSize(width: width * factor, height: height * factor)
	}
}


