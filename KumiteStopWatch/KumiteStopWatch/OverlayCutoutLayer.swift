//
//  OverlayCutoutLayer.swift
//
//  Created by Shane Whitehead on 19/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

/**
	This generates the cutout overlay which used to further "mask" the progress
	I've used this because I like the inner shadowing effect that it can create
*/
public class OverlayCutoutLayer: CAShapeLayer {

	public var thickness: CGFloat = 25 {
		didSet {
			setNeedsLayout()
			setNeedsDisplay()
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
		fillColor = UIColor.whiteColor().CGColor
		strokeColor = UIColor.whiteColor().CGColor
		
		masksToBounds = true
		frame = bounds
		lineWidth = 1
		
		shadowColor = UIColor.blackColor().CGColor
		shadowOffset = CGSize(width: 0, height: 5)
		shadowRadius = CGFloat(10)
		shadowOpacity = 0.5
	}

	public override func layoutSublayers() {
		super.layoutSublayers()
		
		// Outer circle
		let circleRadius = frame.minDimension() / 2
		var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
		circleFrame.origin.x = CGRectGetMidX(bounds) - CGRectGetMidX(circleFrame)
		circleFrame.origin.y = CGRectGetMidY(bounds) - CGRectGetMidY(circleFrame)
		let path = UIBezierPath(ovalInRect: circleFrame)
		
		// Inner circle
		let innerRadius = circleRadius - thickness
		var innerFrame = CGRect(x: 0, y: 0, width: 2 * innerRadius, height: 2 * innerRadius)
		innerFrame.origin.x = CGRectGetMidX(bounds) - CGRectGetMidX(innerFrame)
		innerFrame.origin.y = CGRectGetMidY(bounds) - CGRectGetMidY(innerFrame)
		let innerPath = UIBezierPath(ovalInRect: innerFrame)
		
		// This actually makes a donut (filling the area between the inner and outer
		// paths, but the magic of the  next statement inverts it nicely
		path.appendPath(innerPath.bezierPathByReversingPath())
		
		
		// This represents the outer space
		let rectPath = UIBezierPath(rect: bounds)
		// Cut our the path
		rectPath.appendPath(path.bezierPathByReversingPath())
		
		self.path = rectPath.CGPath
	}

}
