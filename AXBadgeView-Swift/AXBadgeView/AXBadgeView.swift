//
//  AXBadgeView.swift
//  AXBadgeView-Swift
//
//  Created by ai on 16/2/24.
//  Copyright © 2016年 devedbox. All rights reserved.
//

import UIKit

enum AXBadgeViewStyle: Int {
    /// Normal shows a red dot.
    case Normal
    /// Number shows a number form text.
    case Number
    /// Text shows a custom text.
    case Text
    /// New shows a new text.
    case New
}

enum AXBadgeViewAnimation: Int {
    /// Animation none, badge view stay still.
    case None
    /// Animation scale.
    case Scale
    /// Animation shake.
    case Shake
    /// Animation bounce.
    case Bounce
    /// Animation breathe.
    case Breathe
}

class AXBadgeView: UIView {
    var attactView: UIView?
    var style = AXBadgeViewStyle.Normal
    var animation = AXBadgeViewAnimation.None
    var offsets = CGPointMake(0, 0)
    var hideOnZero = false
    var minSize = CGSizeMake(12.0, 12.0)
    var visible:Bool {
        return (superview != nil && !hidden && alpha > 0) ? true : false
    }
}
