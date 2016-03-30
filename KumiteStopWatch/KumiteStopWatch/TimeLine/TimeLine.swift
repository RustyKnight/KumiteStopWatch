//
//  TimeLine.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 22/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

public enum TimeLineAlert {
	case None
	case FlashBackground
	case Vibrate
	case Audio
}

public protocol TimeLineEvent {
	var location: Float {get}
	var color: UIColor {get}
	var alerts: [TimeLineAlert] {get}
	
}

public struct DefaultTimeLineEvent: TimeLineEvent {
	public let location: Float
	public let color: UIColor
	public let alerts: [TimeLineAlert]
}

// I'm wondering which of these is the best approach for a non-mutable
// list of elements

// This is certainly simpler, but doesn't allow for inheritency...
public struct TimeLine {
	public let events: [TimeLineEvent]
}

public class TimeLineBuilder {
	private var events: [TimeLineEvent] = []
	
	public func add(location location: Float, color: UIColor, alerts: TimeLineAlert...) -> TimeLineBuilder {
		add(timeLineEvent: DefaultTimeLineEvent(location: location, color: color, alerts: alerts))
		return self
	}
	
	public func add(timeLineEvent evt: TimeLineEvent) {
		events.append(evt)
	}
	
	public func build() -> TimeLine {
		events.sortInPlace { (evt1, evt2) -> Bool in
			return evt1.location > evt2.location
		}
		
		return TimeLine(events: events)
	}
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