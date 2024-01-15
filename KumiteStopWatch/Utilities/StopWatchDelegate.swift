//
//  StopWatchDelegate.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 31/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation

protocol StopWatchDelegate {
	func stopWatch(_ stopWatchView: StopWatchView, stateDidChange state: AnimationState)
}
