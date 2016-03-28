//
//  NumberExtensions.swift
//  KZCoreLibrary
//
//  Created by Shane Whitehead on 26/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import Foundation

//----- Core numerical extensions -----//

public extension Float {
	public var toRadians : Float {
		return self * Float(M_PI) / 180.0
	}
	public var toDegrees: Float {
		return self * 180 / Float(M_PI)
	}
	public var toDouble: Double {
		return Double(self)
	}
}

public extension Double {
	public var toRadians : Double {
		return self * M_PI / 180.0
	}
	
	public var toDegrees: Double {
		return self * 180 / M_PI
	}
	
	public var toFloat: Float {
		return Float(self)
	}
}
