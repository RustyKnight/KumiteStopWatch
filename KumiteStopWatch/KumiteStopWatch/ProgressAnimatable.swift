//
//  Animatable.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 31/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

/**
	Simply protocol to make animating a number of layers simpler

	Could combine parameters into a single struct ...
*/
public protocol ProgressAnimatable {
	func animateProgressTo(progress: Double, withDurationOf duration:Double, delegate: AnyObject?);
	func pauseAnimation()
	func resumeAnimation()
}