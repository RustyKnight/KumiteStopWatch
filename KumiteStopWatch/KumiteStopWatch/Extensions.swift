//
//  Extensions.swift
//  StopWatchTest02
//
//  Created by Shane Whitehead on 19/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

extension Float {
	var toCGFloat: CGFloat {
		get {
			return CGFloat(self)
		}
	}
	var toRadians : Float {
		return self * Float(M_PI) / 180.0
	}
	var toDegrees: Float {
		return self * 180 / Float(M_PI)
	}
}

extension Double {
	var toCGFloat: CGFloat {
		get {
			return CGFloat(self)
		}
	}
	
	var toRadians : Double {
		return self * M_PI / 180.0
	}

	var toDegrees: Double {
		return self * 180 / M_PI
	}
	
	var toFloat: Float {
		return Float(self)
	}
}

extension CGFloat {
	var toRadians : CGFloat {
		return CGFloat(self) * CGFloat(M_PI) / 180.0
	}
	var toDegrees: CGFloat {
		return self * 180 / CGFloat(M_PI)
	}
}

extension UIEdgeInsets {
	
	func verticalInsets() -> CGFloat {
		return top + bottom
	}
	
	func horizontalInsets() -> CGFloat {
		return left + right
	}
	
}

extension CGRect {
	func fromInsets(insets: UIEdgeInsets) -> CGRect {
		return CGRect(x: CGRectGetMinX(self) + insets.left,
		              y: CGRectGetMinY(self) + insets.top,
		              width: CGRectGetWidth(self) - insets.right,
		              height: CGRectGetHeight(self) - insets.bottom)
	}
}

