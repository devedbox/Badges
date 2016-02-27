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

class AXBadgeView: UILabel {
    var attactView: UIView?
    var style = AXBadgeViewStyle.Normal
    var animation = AXBadgeViewAnimation.None
    var offsets = CGPointMake(CGFloat.max, CGFloat.max) {
        didSet {
            
        }
    }
    var hideOnZero = true
    var minSize = CGSizeMake(12.0, 12.0)
    var scaleContent = false
    var visible:Bool {
        return (superview != nil && !hidden && alpha > 0) ? true : false
    }
    
    private var _textStorage: String? = ""
    
    private var horizontalLayout: NSLayoutConstraint!
    private var verticalLayout: NSLayoutConstraint!
    private lazy var widthLayout: NSLayoutConstraint = { () -> NSLayoutConstraint in
        return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute, relatedBy: <#T##NSLayoutRelation#>, toItem: <#T##AnyObject?#>, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
    }()
    private var heightLayout: NSLayoutConstraint!
    
    private let kAXBadgeViewBreatheAnimationKey = "breathe"
    private let kAXBadgeViewRotateAnimationKey = "rotate"
    private let kAXBadgeViewShakeAnimationKey = "shake"
    private let kAXBadgeViewScaleAnimationKey = "scale"
    private let kAXBadgeViewBounceAnimationKey = "bounce"
    
    override var text:String? {
        get {
            return _textStorage
        }
        set {
            _textStorage = newValue
            switch style {
            case .New:
                super.text = "new"
            case .Text:
                super.text = _textStorage
            case .Number:
                super.text = "\(_textStorage)"
            default:
                super.text = ""
            }
            sizeToFit()
            layer.cornerRadius = bounds.height/2;
            layer.masksToBounds = true
            
            
            guard let _text = self.text else {return}
            if hideOnZero {
                switch style {
                case .Number:
                    if NSString(string: _text).integerValue == 0 {
                        hidden = true
                    } else {
                        hidden = false
                    }
                case .Text:
                    if _text.isEmpty {
                        hidden = true
                    } else {
                        hidden = false
                    }
                case .New: fallthrough
                default: break
                }
            } else {
                hidden = false
            }
        }
    }
    
    enum AXAxis: Int {
        case X
        case Y
        case Z
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    deinit {
        
    }
    
    private func initializer() -> Void {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFontOfSize(12)
        backgroundColor = UIColor.redColor()
        textColor = UIColor.whiteColor()
        textAlignment = NSTextAlignment.Center
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var susize = super.sizeThatFits(size)
        susize.width = max(susize.width + susize.height/2, minSize.width)
        susize.height = max(susize.height, minSize.height)
        return susize
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let _ = newSuperview {
            self.offsets = CGPointMake(offsets.x, offsets.y);
        }
        alpha = 1.0
    }
}