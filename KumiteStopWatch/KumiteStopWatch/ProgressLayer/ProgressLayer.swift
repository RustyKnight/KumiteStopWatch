//
//  ProgressLayer.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 1/04/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

public class ProgressLayer: CALayer {

	public var progress: CGFloat = 0

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override init() {
		super.init()
	}
	
	public override init(layer: AnyObject) {
		super.init(layer: layer)
		if let layer = layer as? ProgressLayer {
			progress = layer.progress
		}
	}
	
	/*
	Override actionForKey: and return a CAAnimation that prepares the animation for that property.
	In our case, we will return an animation for the progress property.
	*/
	public override func actionForKey(event: String) -> CAAction? {
		var action: CAAction?
		if event == "progress" {
			action = self.animationForKey(event)
		} else {
			action = super.actionForKey(event)
		}
		return action
	}
}
