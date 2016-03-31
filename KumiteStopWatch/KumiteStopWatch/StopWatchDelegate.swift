//
//  StopWatchDelegate.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 31/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation

public protocol StopWatchDelegate {
	func stopWatch(stopWatchView: StopWatchView, stateDidChange state: AnimationState)
}