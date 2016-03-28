//
//  StringExtensions.swift
//  KZCoreLibrary
//
//  Created by Shane Whitehead on 25/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation

public extension Int {
	public func zeroPad(withDigits digits: Int) -> String {
		let value = String.localizedStringWithFormat("%%0%dd", digits)
		return String.localizedStringWithFormat(value, self)
	}
}