//
//  ProgressLayer.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 1/04/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class ProgressLayer: CALayer {
    @objc var progress: CGFloat = 0

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init() {
		super.init()
	}
	
	override init(layer: Any) {
		super.init(layer: layer)
		if let layer = layer as? ProgressLayer {
			progress = layer.progress
		}
	}
	
	/*
	Override actionForKey: and return a CAAnimation that prepares the animation for that property.
	In our case, we will return an animation for the progress property.
	*/
    override func action(forKey event: String) -> CAAction? {
		var action: CAAction?
		if event == #keyPath(ProgressLayer.progress) {
			action = self.animation(forKey: event)
		} else {
			action = super.action(forKey: event)
		}
		return action
	}
}
