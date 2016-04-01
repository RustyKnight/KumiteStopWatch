//
//  PieSliceProgressLayer.swift
//
//  Created by Shane Whitehead on 19/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreLibrary
import KZCoreUILibrary

/**
	This is a implementaiton of AngleGradientLayer with a PieSliceLayer mask
	which is used to generate the "progress" animation

	Animation is controlled via the animateProgressTo method, because I've not found
	a means by which I can change the endAngle of the masked layer and have it
	animate by using a property or other "progress" method
*/
public class PieSliceProgressLayer: CALayer, Animatable {
	
	let maskedProgressLayer: PieSliceLayer = PieSliceLayer()
	let progressLayer: PieSliceLayer = PieSliceLayer()
	
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
	
	public var pieSliceProgressLayerDelegate: PieSliceProgressLayerDelegate? {
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
		if let delegate = pieSliceProgressLayerDelegate {
			contents = delegate.contentsFor(self)
		}
	}

	public func startAnimation(withDurationOf duration:Double, withDelegate: AnyObject?) {
		maskedProgressLayer.removeAnimationForKey("endAngle")
		progressLayer.removeAnimationForKey("endAngle")
		
		let anim = CABasicAnimation(keyPath: "endAngle")
		anim.delegate = withDelegate
		
		let range = 360.0
		let angle = range.toCGFloat - 90.0.toCGFloat// + progressLayer.startAngle.toDegrees

		maskedProgressLayer.endAngle = angle
		progressLayer.endAngle = angle
		
		anim.fromValue = -90.0.toRadians
		anim.toValue = angle.toRadians
		anim.duration = duration
		maskedProgressLayer.addAnimation(anim, forKey: "endAngle")
		progressLayer.addAnimation(anim, forKey: "endAngle")
	}

	public func stopAnimation(andReset reset: Bool = false) {
		maskedProgressLayer.removeAnimationForKey("endAngle")
		progressLayer.removeAnimationForKey("endAngle")
		if reset {
			maskedProgressLayer.endAngle = -90.0.toRadians.toCGFloat
			progressLayer.endAngle = -90.0.toRadians.toCGFloat
		}
	}
	
}

public protocol PieSliceProgressLayerDelegate {
	func contentsFor(layer: PieSliceProgressLayer) -> CGImage?;
}