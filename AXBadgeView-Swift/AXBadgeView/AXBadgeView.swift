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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public enum AXBadgeViewStyle: Int {
    /// Normal shows a red dot.
    case normal
    /// Number shows a number form text.
    case number
    /// Text shows a custom text.
    case text
    /// New shows a new text.
    case new
}

public enum AXBadgeViewAnimation: Int {
    /// Animation none, badge view stay still.
    case none
    /// Animation scale.
    case scale
    /// Animation shake.
    case shake
    /// Animation bounce.
    case bounce
    /// Animation breathe.
    case breathe
}

private enum AXAxis: Int {
    case x
    case y
    case z
}

public protocol AXBadgeViewDelegate {
    /// Badge view property.
    var badgeView: AXBadgeView {get set}
    /// Animated to show the badge view.
    func showBadge(animated: Bool) -> Void
    /// Animated to hide the badge view.
    func clearBadge(animated: Bool) -> Void
}

extension UIView: AXBadgeViewDelegate {
    fileprivate struct AssociatedKeys {
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
    public func showBadge(animated: Bool) -> Void {
        badgeView.show(animated: animated, inView: self)
    }
    public func clearBadge(animated: Bool) -> Void {
        badgeView.hide(animated: animated)
    }
}

extension UIBarButtonItem: AXBadgeViewDelegate {
    fileprivate struct AssociatedKeys {
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
    public func showBadge(animated: Bool) -> Void {
        badgeView.show(animated: animated, inView: self.value(forKey: "_view") as? UIView)
    }
    public func clearBadge(animated: Bool) -> Void {
        badgeView.hide(animated: animated)
    }
}

extension UITabBarItem: AXBadgeViewDelegate {
    fileprivate struct AssociatedKeys {
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
    public func showBadge(animated: Bool) -> Void {
        badgeView.show(animated: animated, inView: self.value(forKey: "_view") as? UIView)
    }
    public func clearBadge(animated: Bool) -> Void {
        badgeView.hide(animated: animated)
    }
}



public class AXBadgeView: UILabel {
    /// Attach view.
    weak var attachView: UIView!
    /// Limited number to show text on .Number style.
    open var limitedNumber: Int = 99
    /// Style of badge view. Defaults to AXBadgeViewNormal.
    open var style = AXBadgeViewStyle.normal {
        didSet {
            self.text = _textStorage
        }
    }
    /// Animation type of badge view. Defaults to None.
    open var animation = AXBadgeViewAnimation.none {
        didSet {
            switch animation {
            case .breathe:
                layer.add(_breathingAnimation(duration: 1.2), forKey: kAXBadgeViewBreatheAnimationKey)
            case .bounce:
                layer.add(_bounceAnimation(repeatCount: FLT_MAX, duration: 0.8, fromLayer: layer), forKey: kAXBadgeViewBounceAnimationKey)
            case .scale:
                layer.add(_scaleAnimation(fromScale: 1.2, toScale: 0.8, duration: 0.8, repeatCount: FLT_MAX), forKey: kAXBadgeViewScaleAnimationKey)
            case .shake:
                layer.add(_shakeAnimation(repeatCount: FLT_MAX, duration: 0.8, fromLayer: layer), forKey: kAXBadgeViewShakeAnimationKey)
            default:
                layer.removeAllAnimations()
            }
        }
    }
    /// Offsets, Defaults to (CGFLOAT_MAX, CGFLOAT_MIN).
    open var offsets = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.leastNormalMagnitude) {
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
                
                if centerXConstant == CGFloat.leastNormalMagnitude || centerXConstant == 0.0 {
                    horizontalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: suview, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0)
                } else if centerXConstant == CGFloat.greatestFiniteMagnitude || centerXConstant == suview.bounds.width {
                    horizontalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: suview, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0.0)
                } else {
                    horizontalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: suview, attribute: NSLayoutAttribute.right, multiplier: centerXConstant/suview.bounds.width, constant: 0.0)
                }
                
                if centerYConstant == CGFloat.leastNormalMagnitude || centerYConstant == 0.0 {
                    verticalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: suview, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
                } else if centerYConstant == CGFloat.greatestFiniteMagnitude || centerYConstant == suview.bounds.height {
                    verticalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: suview, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
                } else {
                    verticalLayout = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: suview, attribute: NSLayoutAttribute.bottom, multiplier: centerYConstant/suview.bounds.height, constant: 0.0)
                }
                
                superview?.addConstraint(horizontalLayout)
                superview?.addConstraint(verticalLayout)
                superview?.setNeedsDisplay()
            }
        }
    }
    /// Hide on zero content. Defaults to YES.
    open var hideOnZero = true
    /// Min size. Defaults to {12.0, 12.0}.
    open var minSize = CGSize(width: 12.0, height: 12.0) {
        didSet {
            sizeToFit()
            text = _textStorage
        }
    }
    /// Scale content when set new content to badge label. Defaults to NO.
    open var scaleContent = false
    /// Is badge visible.
    open var visible:Bool {
        return (superview != nil && !isHidden && alpha > 0) ? true : false
    }
    
    fileprivate var _textStorage: String = ""
    
    fileprivate var horizontalLayout: NSLayoutConstraint!
    fileprivate var verticalLayout: NSLayoutConstraint!
    fileprivate lazy var widthLayout: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
    fileprivate lazy var heightLayout: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
    
    fileprivate let kAXBadgeViewBreatheAnimationKey = "breathe"
    fileprivate let kAXBadgeViewRotateAnimationKey = "rotate"
    fileprivate let kAXBadgeViewShakeAnimationKey = "shake"
    fileprivate let kAXBadgeViewScaleAnimationKey = "scale"
    fileprivate let kAXBadgeViewBounceAnimationKey = "bounce"
    
    override open var text:String? {
        get {
            return super.text
        }
        set {
            _textStorage = newValue ?? ""
            switch style {
            case .new:
                super.text = "new"
            case .text:
                super.text = _textStorage
            case .number:
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
                case .number:
                    if NSString(string: _text).integerValue == 0 {
                        isHidden = true
                    } else {
                        isHidden = false
                    }
                case .text:
                    if _text.isEmpty {
                        isHidden = true
                    } else {
                        isHidden = false
                    }
                case .new: fallthrough
                default: break
                }
            } else {
                isHidden = false
            }
        }
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
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
    fileprivate func initializer() -> Void {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 12)
        backgroundColor = UIColor.red
        textColor = UIColor.white
        textAlignment = NSTextAlignment.center
        style = AXBadgeViewStyle.normal
    }
    /// - override: sizeThatFits
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var susize = super.sizeThatFits(size)
        susize.width = max(susize.width + susize.height/2, minSize.width)
        susize.height = max(susize.height, minSize.height)
        return susize
    }
    /// - override: willMoveToSuperview
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let _ = newSuperview {
            self.offsets = CGPoint(x: offsets.x, y: offsets.y);
        }
        alpha = 1.0
    }
    /// - override: didMoveToSuperview
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let suview = superview {
            self.offsets = CGPoint(x: offsets.x, y: offsets.y)
            if !suview.constraints.contains(verticalLayout) {
                suview.addConstraint(verticalLayout)
            }
            if !suview.constraints.contains(horizontalLayout) {
                suview.addConstraint(horizontalLayout)
            }
            suview.setNeedsDisplay()
            suview.bringSubview(toFront: self)
        }
    }
    /// Show badge view in a target view with animation.
    ///
    /// - parameter animated: animated to show badge view or not.
    /// - parameter inView: the target view to add badge view.
    /// 
    /// - returns: Void.
    open func show(animated:Bool, inView view: UIView? = nil)->Void {
        attachView = view
        attachView?.addSubview(self)
        if isHidden {
            isHidden = false
        }
        if alpha < 1.0 {
            alpha = 1.0
        }
        transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: UIViewAnimationOptions(rawValue: 7), animations: { [unowned self]() -> Void in
                    self.transform = CGAffineTransform.identity
                }, completion: { (finished: Bool) -> Void in
                })
        } else {
            transform = CGAffineTransform.identity
        }
    }
    /// Hide the badge view with animation.
    ///
    /// - parameter animated: animated to hide or not.
    /// - parameter completion: completion block call back when the badge view finished hiding.
    ///
    /// - returns: Void.
    open func hide(animated: Bool, completion:(()->())? = nil) -> Void {
        if animated {
            UIView.animate(withDuration: 0.35, animations: { [unowned self]() -> Void in
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
private func _breathingAnimation(duration:TimeInterval) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1.0
    animation.toValue = 0.1
    animation.autoreverses = true
    animation.duration = duration
    animation.repeatCount = FLT_MAX
    animation.isRemovedOnCompletion = false
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
private func _breathingAnimation(repeating:Float, duration: TimeInterval) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1.0
    animation.toValue = 0.1
    animation.autoreverses = true
    animation.duration = duration
    animation.repeatCount = repeating
    animation.isRemovedOnCompletion = false
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
private func _rotationAnimation(duration: TimeInterval, degree: CGFloat, direction: AXAxis, repeatCount: Float) -> CABasicAnimation {
    var animation: CABasicAnimation!
    let axisArr = ["transform.rotation.x", "transform.rotation.y", "transform.rotation.z"]
    animation = CABasicAnimation(keyPath: axisArr[direction.rawValue])
    animation.fromValue = 0
    animation.toValue = degree
    animation.autoreverses = true
    animation.duration = duration
    animation.repeatCount = repeatCount
    animation.isRemovedOnCompletion = false
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
private func _scaleAnimation(fromScale from: Float, toScale: Float, duration: TimeInterval, repeatCount: Float) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "transform.scale")
    animation.fromValue = from
    animation.toValue = toScale
    animation.duration = duration
    animation.autoreverses = true
    animation.repeatCount = repeatCount
    animation.isRemovedOnCompletion = false
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
private func _shakeAnimation(repeatCount: Float, duration: TimeInterval, fromLayer layer: CALayer) -> CAKeyframeAnimation {
    let originSize = layer.bounds.size
    let hOffset = originSize.width/4;
    let animation = CAKeyframeAnimation(keyPath: "transform")
    animation.values = [NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),NSValue(caTransform3D: CATransform3DMakeTranslation(-hOffset, 0, 0)),NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),NSValue(caTransform3D: CATransform3DMakeTranslation(hOffset, 0, 0)),NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0))]
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
private func _bounceAnimation(repeatCount: Float, duration: TimeInterval, fromLayer layer: CALayer) -> CAKeyframeAnimation {
    let originSize = layer.bounds.size
    let hOffset = originSize.height/4;
    let animation = CAKeyframeAnimation(keyPath: "transform")
    animation.values = [NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),NSValue(caTransform3D: CATransform3DMakeTranslation(0, -hOffset, 0)),NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0)),NSValue(caTransform3D: CATransform3DMakeTranslation(0, hOffset, 0)),NSValue(caTransform3D: CATransform3DMakeTranslation(0, 0, 0))]
    animation.repeatCount = repeatCount
    animation.duration = duration
    animation.fillMode = kCAFillModeForwards
    return animation
}
