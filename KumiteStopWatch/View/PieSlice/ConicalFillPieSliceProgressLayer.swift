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


class ConicalFillPieSliceProgressLayer: PieSliceProgressLayer, Colorful {
    override var frame: CGRect {
        didSet { invalidateBuffer() }
    }
    
    var colorBand: ColorBand? {
        didSet { invalidateBuffer() }
    }
    
    var buffer: UIImage?
    
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
        if let layer = layer as? ConicalFillPieSliceProgressLayer {
            colorBand = layer.colorBand
        }
    }
    
    func invalidateBuffer() {
        buffer = nil
    }
    
    override func configure() {
        super.configure()
        needsDisplayOnBoundsChange = true
        pieSliceProgressLayerDelegate = self
    }

}

extension ConicalFillPieSliceProgressLayer: PieSliceProgressLayerDelegate {
    func contentsFor(layer: PieSliceProgressLayer) -> CGImage? {
        if buffer == nil {
            if let colorBand = colorBand {
                //			let diameter = bounds.minDimension()
                let size = bounds.size
                let mask = KZGraphicsUtilities.createRadialGraidentOf(
                    size: size,
                    withColors: [UIColor.black, UIColor.white],
                    withLocations: [0.75, 1.0])
                let master = KZGraphicsUtilities.createConicalGraidentOf(
                    size: size,
                    withColorBand: colorBand)
                
                buffer = master.maskWith(mask)
            }
        }
        var image: CGImage?
        if let buffer = buffer {
            image = buffer.cgImage
        }
        return image
    }
}
