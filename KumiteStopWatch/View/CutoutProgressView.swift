//
//  ProgressView.swift
//  StopWatchTest02
//
//  Created by Shane Whitehead on 14/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreUILibrary

/**
 This is the "base" view ontop of which the cut out layer and the
 pie slice layer are placed
 */
@IBDesignable
class CutoutProgressView: UIView {
    
    let progressLayer: PieSliceProgressLayer = PieSliceProgressLayer()
    let cutoutLayer: OverlayCutoutLayer = OverlayCutoutLayer()
    
    @IBInspectable override var backgroundColor: UIColor? {
        didSet {
            if let backgroundColor = backgroundColor {
                cutoutLayer.fillColor = backgroundColor.cgColor
                cutoutLayer.strokeColor = backgroundColor.cgColor
            } else {
                cutoutLayer.fillColor = nil
                cutoutLayer.strokeColor = nil
            }
        }
    }
    
    @IBInspectable var trackColor: UIColor? {
        set(newValue) {
            super.backgroundColor = newValue
        }
        
        get {
            return super.backgroundColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set(newValue) {
            if let shadowColor = newValue {
                cutoutLayer.shadowColor = shadowColor.cgColor
            } else {
                cutoutLayer.shadowColor = nil
            }
        }
        
        get {
            var color: UIColor? = nil
            if let theColor = cutoutLayer.shadowColor {
                color = UIColor(cgColor: theColor)
            }
            return color
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set(newValue) {
            cutoutLayer.shadowOpacity = newValue
        }
        
        get {
            return cutoutLayer.shadowOpacity
        }
    }
    
    @IBInspectable var strokeColor: UIColor? {
        set(newValue) {
            if let strokeColor = newValue {
                cutoutLayer.strokeColor = strokeColor.cgColor
                cutoutLayer.lineWidth = 1
            } else {
                cutoutLayer.strokeColor = nil
                cutoutLayer.lineWidth = 0
            }
            setNeedsDisplay()
        }
        
        get {
            var color: UIColor? = nil
            if let theColor = cutoutLayer.strokeColor {
                color = UIColor(cgColor: theColor)
            }
            return color
        }
    }
    
    @IBInspectable var progressLineWidth: CGFloat {
        set(newValue) {
            progressLayer.lineWidth = newValue
            setNeedsDisplay()
        }
        
        get {
            return progressLayer.lineWidth
        }
    }
    
    @IBInspectable var progressStrokeColor: UIColor? {
        set(newValue) {
            progressLayer.strokeColor = newValue
            setNeedsDisplay()
        }
        
        get {
            return progressLayer.strokeColor
        }
    }
    
    @IBInspectable var cutoutThickness: CGFloat {
        set(newValue) {
            cutoutLayer.thickness = newValue
        }
        
        get {
            return cutoutLayer.thickness
        }
    }
    
    private let animationManager: AnimationManager = AnimationManager()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
        backgroundColor = UIColor.black
        
        animationManager.animatables.append(progressLayer)
        
        // Cutout based properties
        cutoutThickness = 25.0
        
        let timeLine = TimeLineBuilder(
            withName: "Kumite",
            withDurationOf: 2.0 * 60.0,
            andIsPausable: true
        )
        //				startWithColor: UIColor.green,
        //				endWithColor: UIColor.red)
            .startWith(color: UIColor.green, alerts: TimeLineAlert.None)
            .add(location: 0.75, color: UIColor.yellow, alerts: TimeLineAlert.None)
            .endWith(color: UIColor.red, alerts: TimeLineAlert.None)
            .build()
        
        let delegate = ConicalFillPieSliceDelegate()
        delegate.colorBand = timeLine.colorBand
        
        progressLayer.pieSliceProgressLayerDelegate = delegate
        progressLayer.strokeColor = nil
        progressLayer.lineWidth = 0
        progressLayer.frame = bounds
        cutoutLayer.frame = bounds
        layer.addSublayer(progressLayer)
        layer.addSublayer(cutoutLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.frame = bounds
        cutoutLayer.frame = bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        switch (animationManager.currentState()) {
        case .stopped:
            animationManager.start(withDurationOf: 10, withDelegate: self)
        case .running:
            animationManager.pause()
        case .paused:
            animationManager.resume()
        }
    }
}

extension CutoutProgressView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationManager.stop()
    }
}

class ConicalFillPieSliceDelegate: PieSliceProgressLayerDelegate {
    
    var colorBand: ColorBand?
    private var buffer: UIImage?
    
    func contentsFor(layer: PieSliceProgressLayer) -> CGImage? {
        if buffer == nil {
            if let colorBand = colorBand {
                //			let diameter = bounds.minDimension()
                let size = layer.bounds.size
                let master = KZGraphicsUtilities.createConicalGraidentOf(
                    size: size,
                    withColorBand: colorBand)
                
                buffer = master
            }
        }
        var image: CGImage?
        if let buffer = buffer {
            image = buffer.cgImage
        }
        return image
    }
}
