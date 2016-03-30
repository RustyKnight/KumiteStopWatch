//
//  AnimationStateMonitor.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 21/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

public enum AnimationState {
	case Running
	case Stopped
	case Paused
}

// I'm so tempted right now to make this an extension to CALayer
//public protocol Animatable {
//	func pauseAnimation()
//	func resumeAnimation()
//}

// No more need to repeat all that code every time
// This comes from the Advance Animation Tips docs, so I'd kind
// of interested if this stops ALL the animations for layer (which
// based on my reading it does)
extension CALayer {
	
	func pauseAnimation() {
		let pausedTime = convertTime(CACurrentMediaTime(), fromLayer: nil)
		timeOffset = pausedTime
		speed = 0.0
	}
	
	func resumeAnimation() {
		speed = 1.0
		let pausedTime = timeOffset
		timeOffset = 0.0
		beginTime = 0.0
		let timeSincePause = convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
		beginTime = timeSincePause
	}
}

/**
The purpose of this class is to make it easier to monitor the current animation
state of a view, so it can be more easily paused/resumed.

I'd love to make this a delegate of the animaitons, but as I understand it, that's
kind of a bad idea, as the view is suppose to be taking responsibility for that

This means that the caller is still responsible for managing so of the state, but
the core functionality is mainatined by a single class, rather then any number of 
flags and algorithims
*/
public class AnimationStateMonitor {
	private var state: AnimationState = .Stopped
	
//	public func pauseOrResume(layer: CALayer!) {
//		switch (state) {
//		case .Running:
//			layer.pauseAnimation()
//			state = .Paused
//		case .Paused:
//			layer.resumeAnimation()
//			state = .Running
//		default:
//			break
//		}
//	}
	
	public func paused() {
		state = .Paused
	}
	
	public func running() {
		state = .Running
	}
	
	public func started() {
		state = .Running
	}
	
	public func stopped() {
		state = .Stopped
	}
	
	public func currentState() -> AnimationState {
		return state
	}
}
