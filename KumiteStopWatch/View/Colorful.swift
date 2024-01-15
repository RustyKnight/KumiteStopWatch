//
//  Colorful.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 31/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreUILibrary

/**
	This is probably the worse name for a protocol EVER, but I'm having
	a hard time trying to think up a good one...
	- ColorGradientable...
	- ColorBandable?
	- ColorMeCrazy?

	Basically, there are a number of layers that use the ColorBand from the TimeLine
	for updating their states, but they don't actually need the TimeLine itself, just
	the ColorBand information
*/
public protocol Colorful {
	var colorBand: ColorBand? {set get}
}
