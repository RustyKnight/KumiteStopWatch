//
//  TimeLine.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 22/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation

public protocol TimeLineEvent {
	func time() -> Double;
}

// I'm wondering which of these is the best approach for a non-mutable
// list of elements

// This is certainly simpler, but doesn't allow for inheritency...
public struct TimeLine<E: TimeLineEvent> {
	public let events: [E]
}

//public protocol TimeLine {
//	associatedtype Value
//	func length() -> Int
//	func eventAt(index: Int) -> Value
//}
//
//public class MutableTimeLine<E: TimeLineEvent>: TimeLine {
//	
//	private var events: [E] = []
//	
//	public init() {
//	}
//
//	public init(events: [E]) {
//		self.events = events
//	}
//	
//	public func length() -> Int {
//		return events.count
//	}
//	
//	public func eventAt(index: Int) -> E {
//		return events[index]
//	}
//	
//	public func add(event: E) -> MutableTimeLine<E> {
//		// Should I care about sorting the array?
//		events.append(event)
//		events.sortInPlace { (event1, event2) -> Bool in
//			return event1.time() > event2.time()
//		}
//		return self
//	}
//	
//}