//
//    AXBadgeView.swift
//    AXBadgeView-Swift
//
//    The MIT License (MIT)
//
//    Copyright (c) 2016 devedbox.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.


import UIKit

public enum AXBadgeViewStyle: Int {
    /// Normal shows a red dot.
    case Normal
    /// Number shows a number form text.
    case Number
    /// Text shows a custom text.
    case Text
    /// New shows a new text.
    case New
}

public enum AXBadgeViewAnimation: Int {
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

private enum AXAxis: Int {
    case X
    case Y
    case Z
}

public protocol AXBadgeViewDelegate {
    /// Badge view property.
    var badgeView: AXBadgeView {get set}
    /// Animated to show the badge view.
    func showBadge(animated animated: Bool) -> Void
    /// Animated to hide the badge view.
    func clearBadge(animated animated: Bool) -> Void
}

extension UIView: AXBadgeViewDelegate {
    private struct AssociatedKeys {
        static var key = "badgeViewKey"
    }
    public var badgeView: AXBadgeView {
        get {
            if let badge = objc_getAssociatedObject(self, &AssociatedKeys.key) as? AXBadgeView {
                return badge
            }
            let badge = AXBadgeView()
            objc_setAssociatedObject(self, &AssociatedKeys.key, badge, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return badge
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func showBadge(animated animated: Bool) -> Void {
        badgeView.show(animated: animated, inView: self)
    }
    public func clearBadge(animated animated: Bool) -> Void {
        badgeView.hide(animated: animated)
    }
}

extension UIBarButtonItem: AXBadgeViewDelegate {
    private struct AssociatedKeys {
        static var key = "badgeViewKey"
    }
    public var badgeView: AXBadgeView {
        get {
            if let badge = objc_getAssociatedObject(self, &AssociatedKeys.key) as? AXBadgeView {
                return badge
            }
            let badge = AXBadgeView()
            objc_setAssociatedObject(self, &AssociatedKeys.key, badge, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return badge
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func showBadge(animated animated: Bool) -> Void {
        badgeView.show(animated: animated, inView: self.valueForKey("_view") as? UIView)
    }
    public func clearBadge(animated animated: Bool) -> Void {
        badgeView.hide(animated: animated)
    }
}

extension UITabBarItem: AXBadgeViewDelegate {
    private struct AssociatedKeys {
        static var key = "badgeViewKey"
    }
    public var badgeView: AXBadgeView {
        get {
            if let badge = objc_getAssociatedObject(self, &AssociatedKeys.key) as? AXBadgeView {
                return badge
            }
            let badge = AXBadgeView()
            objc_setAssociatedObject(self, &AssociatedKeys.key, badge, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return badge
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func showBadge(animated animated: Bool) -> Void {
        badgeView.show(animated: animated, inView: self.valueForKey("_view") as? UIView)
    }
    public func clearBadge(animated animated: Bool) -> Void {
        badgeView.hide(animated: animated)
    }
}

public class AXBadgeView: UILabel {
    /// Attach view.
    weak var attachView: UIView!
    /// Limited number to show text on .Number style.
    public var limitedNumber: Int = 99
    /// Style of badge view. Defaults to AXBadgeViewNormal.
    public var style = AXBadgeViewStyle.Normal {
        didSet {
            self.text = _textStorage
        }
    }
    /// Animation type of badge view. Defaults to None.
    public var animation = AXBadgeViewAnimation.None {
        didSet {
            switch animation {
            case .Breathe:
                layer.addAnimation(_breathingAnimation(duration: 1.2), forKey: kAXBadgeViewBreatheAnimationKey)
            case .Bounce:
                layer.addAnimation(_bounceAnimation(repeatCount: FLT_MAX, duration: 0.8, fromLayer: layer), forKey: kAXBadgeViewBounceAnimationKey)
            case .Scale:
                layer.addAnimation(_scaleAnimation(fromScale: 1.2, toScale: 0.8, duration: 0.8, repeatCount: FLT_MAX), forKey: kAXBadgeViewScaleAnimationKey)
            case .Shake:
                layer.addAnimation(_shakeAnimation(repeatCount: FLT_MAX, duration: 0.8, fromLayer: layer), forKey: kAXBadgeViewShakeAnimationKey)
            default:
                layer.removeAllAnimations()
            }
        }
    }
    /// Offsets, Defaults to (CGFLOAT_MAX, CGFLOAT_MIN).
    public var offsets = CGPointMake(CGFloat.max, CGFloat.min) {
        didSet {
            if let suview = superview {
                let centerXConstant = offsets.x
                let centerYConstant = offsets.y
                
                if let _ = horizontalLayout {
                    if suview.constraints.contains(horizontalLayout) {
                        superview?.removeConstraint(horizontalLayout)
                    }
                }
                if let _ = verticalLayout {
                    if suview.constraints.contains(verticalLayout) {
                        superview?.removeConstraint(verticalLayout)
                    }
                }
                
                if centerXConstant == CGFloat.min || centerXConstant == 0.0 {
                    horizontalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: suview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0)
                } else if centerXConstant == CGFloat.max || centerXConstant == suview.bounds.width {
                    horizontalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: suview, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0)
                } else {
                    horizontalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: suview, attribute: NSLayoutAttribute.Right, multiplier: centerXConstant/suview.bounds.width, constant: 0.0)
                }
                
                if centerYConstant == CGFloat.min || centerYConstant == 0.0 {
                    verticalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: suview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
                } else if centerYConstant == CGFloat.max || centerYConstant == suview.bounds.height {
                    verticalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: suview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
                } else {
                    verticalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: suview, attribute: NSLayoutAttribute.Bottom, multiplier: centerYConstant/suview.bounds.height, constant: 0.0)
                }
                
                superview?.addConstraint(horizontalLayout)
                superview?.addConstraint(verticalLayout)
                superview?.setNeedsDisplay()
            }
        }
    }
    /// Hide on zero content. Defaults to YES.
    public var hideOnZero = true
    /// Min size. Defaults to {12.0, 12.0}.
    public var minSize = CGSizeMake(12.0, 12.0) {
        didSet {
            sizeToFit()
            text = _textStorage
        }
    }
    /// Scale content when set new content to badge label. Defaults to NO.
    public var scaleContent = false
    /// Is badge visible.
    public var visible:Bool {
        return (superview != nil && !hidden && alpha > 0) ? true : false
    }
    
    private var _textStorage: String = ""
    
    private var horizontalLayout: NSLayoutConstraint!
    private var verticalLayout: NSLayoutConstraint!
    private lazy var widthLayout: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
    private lazy var heightLayout: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
    
    private let kAXBadgeViewBreatheAnimationKey = "breathe"
    private let kAXBadgeViewRotateAnimationKey = "rotate"
    private let kAXBadgeViewShakeAnimationKey = "shake"
    private let kAXBadgeViewScaleAnimationKey = "scale"
    private let kAXBadgeViewBounceAnimationKey = "bounce"
    
    override public var text:String? {
        get {
            return super.text
        }
        set {
            _textStorage = newValue ?? ""
            switch style {
            case .New:
                super.text = "new"
            case .Text:
                super.text = _textStorage
            case .Number:
                if Int(_textStorage) > limitedNumber {
                    super.text = "\(limitedNumber)"+"+"
                } else {
                    super.text = "\(_textStorage)"
                }
            default:
                super.text = _textStorage
            }
            sizeToFit()
            layer.cornerRadius = bounds.height/2;
            layer.masksToBounds = true
            
            if !constraints.contains(widthLayout) {
                addConstraint(widthLayout)
            }
            if !constraints.contains(heightLayout) {
                addConstraint(heightLayout)
            }
            
            widthLayout.constant = bounds.width
            heightLayout.constant = bounds.height
            setNeedsLayout()
            if visible {
                if scaleContent {
                    show(animated: true)
                }
            }
            
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
    
    convenience init() {
        self.init(frame:CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializer()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    deinit {
    }
    /// Initializer.
    private func initializer() -> Void {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFontOfSize(12)
        backgroundColor = UIColor.redColor()
        textColor = UIColor.whiteColor()
        textAlignment = NSTextAlignment.Center
        style = AXBadgeViewStyle.Normal
    }
    /// - override: sizeThatFits
    override public func sizeThatFits(size: CGSize) -> CGSize {
        var susize = super.sizeThatFits(size)
        susize.width = max(susize.width + susize.height/2, minSize.width)
        susize.height = max(susize.height, minSize.height)
        return susize
    }
    /// - override: willMoveToSuperview
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let _ = newSuperview {
            self.offsets = CGPointMake(offsets.x, offsets.y);
        }
        alpha = 1.0
    }
    /// - override: didMoveToSuperview
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let suview = superview {
            self.offsets = CGPointMake(offsets.x, offsets.y)
            if !suview.constraints.contains(verticalLayout) {
                suview.addConstraint(verticalLayout)
            }
            if !suview.constraints.contains(horizontalLayout) {
                suview.addConstraint(horizontalLayout)
            }
            suview.setNeedsDisplay()
            suview.bringSubviewToFront(self)
        }
    }
    /// Show badge view in a target view with animation.
    ///
    /// - parameter animated: animated to show badge view or not.
    /// - parameter inView: the target view to add badge view.
    /// 
    /// - returns: Void.
    public func show(animated animated:Bool, inView view: UIView? = nil)->Void {
        attachView = view
        attachView?.addSubview(self)
        if hidden {
            hidden = false
        }
        if alpha < 1.0 {
            alpha = 1.0
        }
        transform = CGAffineTransformMakeScale(0.0, 0.0)
        if animated {
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: UIViewAnimationOptions(rawValue: 7), animations: { [unowned self]() -> Void in
                    self.transform = CGAffineTransformIdentity
                }, completion: { (finished: Bool) -> Void in
                })
        } else {
            transform = CGAffineTransformIdentity
        }
    }
    /// Hide the badge view with animation.
    ///
    /// - parameter animated: animated to hide or not.
    /// - parameter completion: completion block call back when the badge view finished hiding.
    ///
    /// - returns: Void.
    public func hide(animated animated: Bool, completion: dispatch_block_t? = nil) -> Void {
        if animated {
            UIView.animateWithDuration(0.35, animations: { [unowned self]() -> Void in
                    self.alpha = 0.0
                }, completion: { [unowned self](finished: Bool) -> Void in
                    if finished {
                        self.removeFromSuperview()
                        self.alpha = 1.0
                        completion?()
                    }
                })
        } else {
            self.removeFromSuperview()
            completion?()
        }
    }
}

/// Breath animation.
///
/// - parameter reapeating: repeat count of animation.
///
/// - returns: breath animation.
private func _breathingAnimation(duration duration:NSTimeInterval) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1.0
    animation.toValue = 0.1
    animation.autoreverses = true
    animation.duration = duration
    animation.repeatCount = FLT_MAX
    animation.removedOnCompletion = false
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.fillMode = kCAFillModeForwards
    return animation
}

/// Breath animation.
///
/// - parameter reapeating: repeat count of animation.
/// - parameter duration: animation duration.
/// 
/// - returns: breath animation.
private func _breathingAnimation(repeating repeating:Float, duration: NSTimeInterval) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1.0
    animation.toValue = 0.1
    animation.autoreverses = true
    animation.duration = duration
    animation.repeatCount = repeating
    animation.removedOnCompletion = false
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.fillMode = kCAFillModeForwards
    return animation
}

/// Rotation animation
///
/// - parameter duration: animation duration.
/// - parameter degree: the degree to rotate.
/// - parameter direction: the direction to rotate.
/// - parameter repeatCount: repeat count of animation.
///
/// - returns: rotation animation.
private func _rotationAnimation(duration duration: NSTimeInterval, degree: CGFloat, direction: AXAxis, repeatCount: Float) -> CABasicAnimation {
    var animation: CABasicAnimation!
    let axisArr = ["transform.rotation.x", "transform.rotation.y", "transform.rotation.z"]
    animation = CABasicAnimation(keyPath: axisArr[direction.rawValue])
    animation.fromValue = 0
    animation.toValue = degree
    animation.autoreverses = true
    animation.duration = duration
    animation.repeatCount = repeatCount
    animation.removedOnCompletion = false
    animation.fillMode = kCAFillModeForwards
    return animation
}

/// Scale animation.
///
/// - parameter fromScale: scale value to begin.
/// - parameter duration:  animation duration.
/// - parameter repeatCount: repeat count of animation.
/// 
/// - returns: scale animation.
private func _scaleAnimation(fromScale from: Float, toScale: Float, duration: NSTimeInterval, repeatCount: Float) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "transform.scale")
    animation.fromValue = from
    animation.toValue = toScale
    animation.duration = duration
    animation.autoreverses = true
    animation.repeatCount = repeatCount
    animation.removedOnCompletion = false
    animation.fillMode = kCAFillModeForwards
    return animation
}

/// Shake animation.
///
/// - parameter repeatCount: time
/// - parameter duration:    duration
/// - parameter fromLayer:   layer to add begin.
///
/// - returns: shake animation.
private func _shakeAnimation(repeatCount repeatCount: Float, duration: NSTimeInterval, fromLayer layer: CALayer) -> CAKeyframeAnimation {
    let originSize = layer.bounds.size
    let hOffset = originSize.width/4;
    let animation = CAKeyframeAnimation(keyPath: "transform")
    animation.values = [NSValue(CATransform3D: CATransform3DMakeTranslation(0, 0, 0)),NSValue(CATransform3D: CATransform3DMakeTranslation(-hOffset, 0, 0)),NSValue(CATransform3D: CATransform3DMakeTranslation(0, 0, 0)),NSValue(CATransform3D: CATransform3DMakeTranslation(hOffset, 0, 0)),NSValue(CATransform3D: CATransform3DMakeTranslation(0, 0, 0))]
    animation.repeatCount = repeatCount
    animation.duration = duration
    animation.fillMode = kCAFillModeForwards
    return animation
}

/// Bounce animation.
///
/// - parameter repeatCount: count of repeat times.
/// - parameter duration:    duration of animation.
/// - parameter fromLayer:   layer to add begin.
/// 
/// - returns: bounce animation.
private func _bounceAnimation(repeatCount repeatCount: Float, duration: NSTimeInterval, fromLayer layer: CALayer) -> CAKeyframeAnimation {
    let originSize = layer.bounds.size
    let hOffset = originSize.height/4;
    let animation = CAKeyframeAnimation(keyPath: "transform")
    animation.values = [NSValue(CATransform3D: CATransform3DMakeTranslation(0, 0, 0)),NSValue(CATransform3D: CATransform3DMakeTranslation(0, -hOffset, 0)),NSValue(CATransform3D: CATransform3DMakeTranslation(0, 0, 0)),NSValue(CATransform3D: CATransform3DMakeTranslation(0, hOffset, 0)),NSValue(CATransform3D: CATransform3DMakeTranslation(0, 0, 0))]
    animation.repeatCount = repeatCount
    animation.duration = duration
    animation.fillMode = kCAFillModeForwards
    return animation
}