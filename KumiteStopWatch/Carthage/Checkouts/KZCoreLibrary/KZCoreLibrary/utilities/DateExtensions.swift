//
//  DateUtilities.swift
//  KZCoreLibrary
//
//  Created by Shane Whitehead on 25/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation

public extension NSDate {
	
	/**
		This is itended mostly for simplicty when trying to dump the
		date value and one should use the stringFromDate(NSDate: withFormat:)
		method instead
	*/
	public func stringFromDate() -> String {
		return stringFromDate(withFormat: "dd/MM/yyyy")
	}
	
	public func stringFromDate(withFormat format: String) -> String {
		let formatter = NSDateFormatter()
		formatter.dateFormat = format
		return formatter.stringFromDate(self)
	}

	/** 
	 * Convinence method to subtract a given value from date component
	 */
	public func subtrac(amount: Int, forComponent unit: NSCalendarUnit) -> NSDate? {
		return add(amount * -1, forComponent: unit)
	}
	
	/**
	 * Method to add a given value from date component
	 */
	public func add(amount: Int, forComponent unit: NSCalendarUnit) -> NSDate? {
		let calendar = NSCalendar.currentCalendar()
		let dateComponents: NSDateComponents = NSDateComponents()
		dateComponents.setValue(amount, forComponent: unit)
		return calendar.dateByAddingComponents(
			dateComponents,
			toDate: self,
			options: NSCalendarOptions(rawValue: 0))
	}
	
	/**
	 * Convinence method to subtract a number of months from a date
	 */
	public func subtract(months months: Int) -> NSDate? {
		return add(months: months * -1)
	}
	
	/**
	 * Convinence method to add a number of months from a date
	 */
	public func add(months months: Int) -> NSDate? {
		return add(months, forComponent: NSCalendarUnit.Month)
	}

	/**
	 * Convinence method to add a number of days from a date
	 */
	public func add(days days: Int) -> NSDate? {
		return add(days, forComponent: NSCalendarUnit.Day)
	}
	
	/**
	 * Convinence method to subtract a number of days from a date
	 */
	public func subtract(days days: Int) -> NSDate? {
		return add(days: days * -1)
	}
	
	/**
	* Convinence method to add a number of years from a date
	*/
	public func add(years years: Int) -> NSDate? {
		return add(years, forComponent: NSCalendarUnit.Year)
	}
	
	/**
	* Convinence method to subtract a number of years from a date
	*/
	public func subtract(years years: Int) -> NSDate? {
		return add(years: years * -1)
	}
	
	public func with(hour hour: Int, minute min: Int, seconds: Int, nanoSeconds nanos: Int) -> NSDate? {
		let calendar = NSCalendar.currentCalendar()
		let dateComponents: NSDateComponents = NSDateComponents()
		
		dateComponents.hour = hour
		dateComponents.minute = min
		dateComponents.second = seconds
		dateComponents.nanosecond = nanos
		
		return calendar.dateByAddingComponents(
			dateComponents,
			toDate: self,
			options: NSCalendarOptions(rawValue: 0))
	}
	
	public func timeAtEndOfDay() -> NSDate? {
		return with(hour: 23, minute: 59, seconds: 59, nanoSeconds: 0)
	}
	
	public func timeAtStartOfDay() -> NSDate? {
		return with(hour: 0, minute: 0, seconds: 0, nanoSeconds: 1)
	}
	
	public func isAfter(dateToCompare: NSDate) -> Bool {
		//Declare Variables
		var isAfter = false
		
		//Compare Values
		if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
			isAfter = true
		}
		
		//Return Result
		return isAfter
	}
	
	public func isBefore(dateToCompare: NSDate) -> Bool {
		//Declare Variables
		var isBefore = false
		
		//Compare Values
		if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
			isBefore = true
		}
		
		//Return Result
		return isBefore
	}
	
	public func isEqualTo(dateToCompare: NSDate) -> Bool {
		//Declare Variables
		var isEqualTo = false
		
		//Compare Values
		if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
			isEqualTo = true
		}
		
		//Return Result
		return isEqualTo
	}
	
	public func excludingTimeIsBetween(startDate startDate: NSDate, and endDate: NSDate) -> Bool {
		
		var isBetween = false
		if let startDate = startDate.timeAtStartOfDay() {
			if let endDate = endDate.timeAtEndOfDay() {
				
				if self.isAfter(startDate) && self.isBefore(endDate) {
					isBetween = true
				}
				
			}
		}
		
		return isBetween
		
	}

	public func excludingTimeIsBetweenOrEqualTo(startDate startDate: NSDate, and endDate: NSDate) -> Bool {
		
		var isBetweenOrEqualTo = false
		if let startDate = startDate.subtract(days: 1) {
			if let endDate = endDate.add(days: 1) {

				isBetweenOrEqualTo = excludingTimeIsBetween(startDate: startDate, and: endDate)
				
			}
		}
		
		return isBetweenOrEqualTo
		
	}
	
	public class func daysBetween(fromDate: NSDate, and toDate: NSDate) -> Int? {
		let calendar = NSCalendar.currentCalendar()
		var startDate: NSDate? = nil
		var endDate: NSDate? = nil
		calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &startDate, interval: nil, forDate: fromDate)
		calendar.rangeOfUnit(NSCalendarUnit.Day, startDate: &endDate, interval: nil, forDate: toDate)
		
		var days: Int? = nil
		
		if let startDate = startDate {
			if let endDate = endDate {
				let difference = calendar.components(
					NSCalendarUnit.Day,
					fromDate: startDate,
					toDate: endDate,
					options: NSCalendarOptions(rawValue: 0))
				
				days = difference.day
			}
		}
		return days
	}
	
	public class func todayWithSecondsSinceMidnight(seconds: Int) -> NSDate? {
		if let today = NSDate().timeAtStartOfDay() {
			return today.dateByAddingTimeInterval(NSTimeInterval(seconds))
		}
		return nil
	}
	
	public func dayOfWeek() -> Int {
		return NSDate.dayOfWeekFor(self)
	}
	
	public func dayOfWeek(startinfFrom from: Int) -> Int {
		return NSDate.dayOfWeekFor(self, startingFrom: from)
	}
	
	public class func dayOfWeekFor(date: NSDate) -> Int {
		return NSDate.dayOfWeekFor(date, startingFrom: 1)
	}
	
	public class func dayOfWeekFor(date: NSDate, startingFrom: Int) -> Int {
		
		let calendar = NSCalendar.currentCalendar()
		calendar.firstWeekday = startingFrom
		let dow = calendar.ordinalityOfUnit(NSCalendarUnit.Weekday, inUnit: NSCalendarUnit.WeekOfMonth, forDate: date)
		
		return dow
		
	}
}