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


public class ConicalFillPieSliceProgressLayer: PieSliceProgressLayer {
	
	public var colors: [UIColor] = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()] {
		didSet {
			invalidateBuffer()
		}
	}
	
	public var locations: [Double] = [0.0, 0.5, 1.0]{
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
//			let diameter = bounds.minDimension()
			let size = bounds.size
			let mask = KZGraphicsUtilities.createRadialGraidentOf(
				size: size,
				withColors: [UIColor.blackColor(), UIColor.whiteColor()],
				withLocations: [0.75, 1.0])
			let master = KZGraphicsUtilities.createConicalGraidentOf(
				size: size,
				withColors: colors,
				withLocations: locations)
			
			buffer = master.maskWith(mask)
		}
		var image: CGImage?
		if let buffer = buffer {
			image = buffer.CGImage
		}
		return image
	}
}
