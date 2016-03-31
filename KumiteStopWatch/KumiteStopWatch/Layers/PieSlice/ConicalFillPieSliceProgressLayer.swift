//
//  ConicalFillPieSliceProgressLayer.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 26/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreUILibrary
import QuartzCore


public class ConicalFillPieSliceProgressLayer: PieSliceProgressLayer, Colorful {

	public var colorBand: ColorBand? {
		didSet {
			invalidateBuffer()
		}
	}
	
	var buffer: UIImage?
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configure()
	}
	
	public override init() {
		super.init()
		configure()
	}

	override func	configure() {
		super.configure()
		pieSliceProgressLayerDelegate = self
	}
	
	func invalidateBuffer() {
		buffer = nil
	}

}

extension ConicalFillPieSliceProgressLayer: PieSliceProgressLayerDelegate {
	public func contentsFor(layer: PieSliceProgressLayer) -> CGImage? {
		if buffer == nil {
			if let colorBand = colorBand {
				//			let diameter = bounds.minDimension()
				let size = bounds.size
				let mask = KZGraphicsUtilities.createRadialGraidentOf(
					size: size,
					withColors: [UIColor.blackColor(), UIColor.whiteColor()],
					withLocations: [0.75, 1.0])
				let master = KZGraphicsUtilities.createConicalGraidentOf(
					size: size,
					withColorBand: colorBand)
				
				buffer = master.maskWith(mask)
			}
		}
		var image: CGImage?
		if let buffer = buffer {
			image = buffer.CGImage
		}
		return image
	}
}
