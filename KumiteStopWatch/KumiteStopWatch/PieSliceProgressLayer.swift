//
//  PieSliceProgressLayer.swift
//
//  Created by Shane Whitehead on 19/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

/**
	This is a implementaiton of AngleGradientLayer with a PieSliceLayer mask
	which is used to generate the "progress" animation

	Animation is controlled via the animateProgressTo method, because I've not found
	a means by which I can change the endAngle of the masked layer and have it
	animate by using a property or other "progress" method
*/
public class PieSliceProgressLayer: AngleGradientLayer {
	
	let maskedProgressLayer: PieSliceLayer = PieSliceLayer()
	let progressLayer: PieSliceLayer = PieSliceLayer()
	
	public var contentInsets: UIEdgeInsets {
		set(newValue) {
			maskedProgressLayer.contentInsets = newValue
			progressLayer.contentInsets = newValue
		}
		
		get {
			return maskedProgressLayer.contentInsets
		}
	}
	
	public var lineWidth: CGFloat {
		set(newValue) {
			progressLayer.lineWidth = newValue
		}
		
		get {
			return progressLayer.lineWidth
		}
	}

	public var strokeColor: UIColor? {
		set(newValue) {
			progressLayer.strokeColor = newValue
		}
		
		get {
			return progressLayer.strokeColor
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
		maskedProgressLayer.backgroundColor = UIColor.clearColor().CGColor
		maskedProgressLayer.fillColor = UIColor.blackColor()
		maskedProgressLayer.strokeColor = UIColor.blackColor()
		maskedProgressLayer.lineWidth = 0.0
		maskedProgressLayer.startAngle = -90.0.toRadians.toCGFloat
		maskedProgressLayer.endAngle = -90.0.toRadians.toCGFloat

		progressLayer.backgroundColor = UIColor.clearColor().CGColor
		progressLayer.fillColor = UIColor.clearColor()
		progressLayer.strokeColor = UIColor.blackColor()
		progressLayer.lineWidth = 10
		progressLayer.startAngle = -90.0.toRadians.toCGFloat
		progressLayer.endAngle = -90.0.toRadians.toCGFloat

//		shadowColor = UIColor.blackColor().CGColor
//		shadowOpacity = 1.0
		
		mask = maskedProgressLayer
		addSublayer(progressLayer)
	}
	
	public override func layoutSublayers() {
		super.layoutSublayers()
		maskedProgressLayer.frame = bounds
		progressLayer.frame = bounds
	}

	public func animateProgressTo(progress: Double, withDurationOf duration:Double, delegate: AnyObject?) {
		maskedProgressLayer.removeAnimationForKey("endAngle")
		progressLayer.removeAnimationForKey("endAngle")
		
		let anim = CABasicAnimation(keyPath: "endAngle")
		anim.delegate = delegate
		
		let range = 360.0 * progress
		let angle = range.toCGFloat// + progressLayer.startAngle.toDegrees
		
		anim.fromValue = 0
		anim.toValue = angle.toRadians
		anim.duration = duration
		anim.removedOnCompletion = false
		anim.additive = true
		anim.fillMode = kCAFillModeForwards
		maskedProgressLayer.addAnimation(anim, forKey: "endAngle")
		progressLayer.addAnimation(anim, forKey: "endAngle")
	}
	
}