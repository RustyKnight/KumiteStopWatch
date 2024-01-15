//
//  PieSliceProgressLayer.swift
//
//  Created by Shane Whitehead on 19/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreLibrary
import KZCoreUILibrary
import Cadmus

/**
	This is a implementaiton of AngleGradientLayer with a PieSliceLayer mask
	which is used to generate the "progress" animation

	Animation is controlled via the animateProgressTo method, because I've not found
	a means by which I can change the endAngle of the masked layer and have it
	animate by using a property or other "progress" method
*/
class PieSliceProgressLayer: CALayer, Animatable {
	
	let maskedProgressLayer: PieSliceLayer = PieSliceLayer()
	let progressLayer: PieSliceLayer = PieSliceLayer()
	
	var lineWidth: CGFloat {
		set { progressLayer.lineWidth = newValue }
		get { return progressLayer.lineWidth }
	}

	var strokeColor: UIColor? {
		set { progressLayer.strokeColor = newValue }
		get { return progressLayer.strokeColor }
	}
	
	var pieSliceProgressLayerDelegate: PieSliceProgressLayerDelegate? {
		didSet {
			setNeedsLayout()
			setNeedsDisplay()
		}
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configure()
	}
	
	override init() {
		super.init()
		configure()
	}
	
    override init(layer: Any) {
		super.init(layer: layer)
		if let layer = layer as? PieSliceProgressLayer {
			lineWidth = layer.lineWidth
			strokeColor = layer.strokeColor
			pieSliceProgressLayerDelegate = layer.pieSliceProgressLayerDelegate
		}
	}
	
	func configure() {
		needsDisplayOnBoundsChange = true
		maskedProgressLayer.backgroundColor = UIColor.clear.cgColor
		maskedProgressLayer.fillColor = UIColor.black
		maskedProgressLayer.strokeColor = UIColor.black
		maskedProgressLayer.lineWidth = 0.0
		maskedProgressLayer.startAngle = -90.0.toRadians.toCGFloat
		maskedProgressLayer.endAngle = -90.0.toRadians.toCGFloat

		progressLayer.backgroundColor = UIColor.clear.cgColor
		progressLayer.fillColor = UIColor.clear
		progressLayer.strokeColor = UIColor.black
		progressLayer.lineWidth = 10
		progressLayer.startAngle = -90.0.toRadians.toCGFloat
		progressLayer.endAngle = -90.0.toRadians.toCGFloat
		
		mask = maskedProgressLayer
		addSublayer(progressLayer)
	}
	
	override func layoutSublayers() {
		super.layoutSublayers()
		maskedProgressLayer.frame = bounds
		progressLayer.frame = bounds
		if let delegate = pieSliceProgressLayerDelegate {
            contents = delegate.contentsFor(layer: self)
		}
	}

	func startAnimation(withDurationOf duration: Double, withDelegate: CAAnimationDelegate?) {
        maskedProgressLayer.removeAnimation(forKey: #keyPath(PieSliceLayer.endAngle))
        progressLayer.removeAnimation(forKey: #keyPath(PieSliceLayer.endAngle))
		
		let anim = CABasicAnimation(keyPath: #keyPath(PieSliceLayer.endAngle))
        anim.delegate = withDelegate
		
		let range = 360.0
		let angle = range.toCGFloat - 90.0.toCGFloat// + progressLayer.startAngle.toDegrees

		maskedProgressLayer.endAngle = angle
		progressLayer.endAngle = angle
		
		anim.fromValue = -90.0.toRadians
		anim.toValue = angle.toRadians
		anim.duration = duration
        maskedProgressLayer.add(anim, forKey: #keyPath(PieSliceLayer.endAngle))
        progressLayer.add(anim, forKey: #keyPath(PieSliceLayer.endAngle))
	}

	func stopAnimation(andReset reset: Bool = false) {
        maskedProgressLayer.removeAnimation(forKey: #keyPath(PieSliceLayer.endAngle))
        progressLayer.removeAnimation(forKey: #keyPath(PieSliceLayer.endAngle))
		if reset {
			maskedProgressLayer.endAngle = -90.0.toRadians.toCGFloat
			progressLayer.endAngle = -90.0.toRadians.toCGFloat
		}
	}
	
}

protocol PieSliceProgressLayerDelegate {
	func contentsFor(layer: PieSliceProgressLayer) -> CGImage?;
}
