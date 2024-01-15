//
//  AnimationStateMonitor.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 21/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

enum AnimationState {
	case running
	case stopped
	case paused
}

// No more need to repeat all that code every time
// This comes from the Advance Animation Tips docs, so I'd kind be
// of interested if this stops ALL the animations for layer (which
// based on my reading it does)
extension CALayer {
	func pauseAnimation() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
		timeOffset = pausedTime
		speed = 0.0
	}
	
	func resumeAnimation() {
		speed = 1.0
		let pausedTime = timeOffset
		timeOffset = 0.0
		beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
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
public class AnimationManager {
	var animatables: [Animatable] = []
	
	private var state: AnimationState = .stopped
	
	init() {
	}
	
	init(withAnimatabes animatables: [Animatable]) {
		self.animatables = animatables
	}
	
	func currentState() -> AnimationState {
		return state
	}

	func start(withDurationOf duration: Double, withDelegate delegate: CAAnimationDelegate? = nil) {
		state = .running
		for animtable in animatables {
			animtable.startAnimation(withDurationOf: duration, withDelegate: delegate)
		}
	}
	
	func stop(andReset reset: Bool = false) {
		state = .stopped
		for animtable in animatables {
			animtable.stopAnimation(andReset: reset)
		}
	}

	func pause() {
		state = .paused
		for animtable in animatables {
			animtable.pauseAnimation()
		}
	}
	
	func resume() {
		state = .running
		for animtable in animatables {
			animtable.resumeAnimation()
		}
	}

}

/**
Simply protocol to make animating a number of layers simpler

Could combine parameters into a single struct ...
*/
protocol Animatable {
	func startAnimation(withDurationOf duration:Double, withDelegate: CAAnimationDelegate?)
	func stopAnimation(andReset rest: Bool)
	func pauseAnimation()
	func resumeAnimation()
}
