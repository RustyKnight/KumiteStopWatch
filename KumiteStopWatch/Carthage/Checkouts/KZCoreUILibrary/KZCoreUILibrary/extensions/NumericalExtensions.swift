//
//  Common.swift
//  KZCoreUILibrary
//
//  Created by Shane Whitehead on 25/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreLibrary

public extension Float {
	public var toCGFloat: CGFloat {
		return CGFloat(self)
	}
}

public extension Double {
	public var toCGFloat: CGFloat {
		return CGFloat(self)
	}
}

public extension CGFloat {
	public var toRadians : CGFloat {
		return CGFloat(self) * CGFloat(M_PI) / 180.0
	}

	public var toDegrees: CGFloat {
		return self * 180.0 / CGFloat(M_PI)
	}
	
	public var toDouble: Double {
		return Double(self)
	}
	
	public var toFloat: Float {
		return Float(self)
	}
}

