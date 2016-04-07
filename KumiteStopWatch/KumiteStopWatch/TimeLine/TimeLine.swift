//
//  TimeLine.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 22/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreUILibrary

/**
The support alert types
*/
public enum TimeLineAlert {
	case None
	case FlashBackground
	case Vibrate
	case Audio
}

public struct TimeLineEvent {
	public let location: Double
	public let color: UIColor
	public let alerts: [TimeLineAlert]
}

// I'm wondering which of these is the best approach for a non-mutable
// list of elements

// This is certainly simpler, but doesn't allow for inheritency...
public struct TimeLine {
	public let name: String
	public let duration: NSTimeInterval
	public let events: [TimeLineEvent]
	public let colorBand: ColorBand
	public let pausable: Bool
	
	public init(withName: String, withDuration: NSTimeInterval, isPausable: Bool, andEvents:[TimeLineEvent]) {
		self.name = withName
		self.duration = withDuration
		self.events = andEvents
		self.pausable = isPausable
		
		var colorBandEntries: [ColorBandEntry] = []
		for event in events {
			colorBandEntries.append(ColorBandEntry(withColor: event.color, at: event.location))
		}
		
		colorBand = ColorBand(with: colorBandEntries)
	}
}

/**
Builder pattern for building time lines
*/
public class TimeLineBuilder {
	private var events: [TimeLineEvent] = []
	private var duration: NSTimeInterval
	private var name: String
	private var pausable: Bool
	
	public init(withName name: String, withDurationOf: NSTimeInterval, andIsPausable pausable: Bool) {
		self.duration = withDurationOf
		self.name = name
		self.pausable = pausable
	}
	
	public func startWith(color color: UIColor, alerts: TimeLineAlert...) -> TimeLineBuilder {
		add(timeLineEvent: TimeLineEvent(location: 0.0, color: color, alerts: alerts))
		return self
	}
	
	public func endWith(color color: UIColor, alerts: TimeLineAlert...) -> TimeLineBuilder {
		add(timeLineEvent: TimeLineEvent(location: 1.0, color: color, alerts: alerts))
		return self
	}
	
	public func add(location location: Double, color: UIColor, alerts: TimeLineAlert...) -> TimeLineBuilder {
		add(timeLineEvent: TimeLineEvent(location: location, color: color, alerts: alerts))
		return self
	}
	
	public func add(timeLineEvent evt: TimeLineEvent) {
		events.append(evt)
	}
	
	public func build() -> TimeLine {
		events.sortInPlace { (evt1, evt2) -> Bool in
			return evt1.location < evt2.location
		}
		
		return TimeLine(withName: name, withDuration: duration, isPausable: pausable, andEvents: events)
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