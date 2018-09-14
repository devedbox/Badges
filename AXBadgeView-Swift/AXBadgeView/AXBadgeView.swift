//
// AXBadgeView.swift
// AXBadgeView-Swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 devedbox.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

// MARK: - Types.

extension AXBadgeView {
  
  // MARK: Style.
  
  /// The style of the badge view.
  public enum Style {
    case normal // Shows a red dot only.
    case number(value: Int) // Shows a number text.
    case text(value: String) // Shows a custom text.
    case new // Shows a 'new' text.
  }
  
  // MARK: Animator.
  
  /// The animation type of the badge view.
  public enum Animator: String {
    case none // None animator, badge view stay still.
    case scale // Sacle animator
    case shaking // Shake animator.
    case bounce // Bounce animator.
    case breathing // Breathing animator.
  }
  
  // MARK: Offset.
  
  /// The offset of a rectangle at any size.
  public enum Offset {
    case least
    case exact(CGFloat)
    case greatest
  }
  
  /// The offsets of the badge view.
  public struct Offsets {
    public var x: Offset
    public var y: Offset
    
    public static func offsets(
      x: Offset,
      y: Offset) -> Offsets
    {
      return Offsets(x: x, y: y)
    }
  }
}

// MARK: - AXBadgeViewDelegate.

public protocol AXBadgeViewDelegate {
  /// Badge view property.
  var badgeView: AXBadgeView { get set }
  /// Animated to show the badge view.
  func showBadge(animated: Bool) -> Void
  /// Animated to hide the badge view.
  func clearBadge(animated: Bool) -> Void
}

// MARK: - UIView.

extension UIView: AXBadgeViewDelegate {
  /// The associated keys.
  private struct _AssociatedKeys {
    /// Key for `badgeView`.
    static var badgeView = "badgeViewKey"
  }
  /// Returns the badge view of the receiver.
  public var badgeView: AXBadgeView {
    get {
      if let badge = objc_getAssociatedObject(self, &_AssociatedKeys.badgeView) as? AXBadgeView {
        return badge
      }
      
      let badge = AXBadgeView()
      objc_setAssociatedObject(
        self,
        &_AssociatedKeys.badgeView,
        badge,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
      return badge
    }
    
    set {
      objc_setAssociatedObject(
        self,
        &_AssociatedKeys.badgeView,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  public func showBadge(
    animated: Bool) -> Void
  {
    badgeView.show(
      animated: animated,
      inView: self
    )
  }
  
  public func clearBadge(
    animated: Bool) -> Void
  {
    badgeView.hide(
      animated: animated
    )
  }
}

// MARK: - UIBarButtonItem.

extension UIBarButtonItem: AXBadgeViewDelegate {
  private struct _AssociatedKeys {
    static var badgeView = "badgeViewKey"
  }
  
  public var badgeView: AXBadgeView {
    get {
      if let badge = objc_getAssociatedObject(self, &_AssociatedKeys.badgeView) as? AXBadgeView {
        return badge
      }
      let badge = AXBadgeView()
      objc_setAssociatedObject(
        self, &_AssociatedKeys.badgeView,
        badge,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
      return badge
    }
    set {
      objc_setAssociatedObject(
        self,
        &_AssociatedKeys.badgeView,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  public func showBadge(
    animated: Bool) -> Void
  {
    badgeView.show(
      animated: animated,
      inView: self.value(forKey: "view") as? UIView
    )
  }
  
  public func clearBadge(
    animated: Bool) -> Void
  {
    badgeView.hide(
      animated: animated
    )
  }
}

// MARK: - UITabBarItem.

extension UITabBarItem: AXBadgeViewDelegate {
  private struct _AssociatedKeys {
    static var badgeView = "badgeViewKey"
  }
  
  public var badgeView: AXBadgeView {
    get {
      if let badge = objc_getAssociatedObject(self, &_AssociatedKeys.badgeView) as? AXBadgeView {
        return badge
      }
      let badge = AXBadgeView()
      objc_setAssociatedObject(
        self,
        &_AssociatedKeys.badgeView,
        badge,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
      return badge
    }
    set {
      objc_setAssociatedObject(
        self,
        &_AssociatedKeys.badgeView,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  public func showBadge(
    animated: Bool) -> Void
  {
    badgeView.show(
      animated: animated,
      inView: value(forKey: "view") as? UIView
    )
  }
  
  public func clearBadge(
    animated: Bool) -> Void
  {
    badgeView.hide(
      animated: animated
    )
  }
}

// MARK: - AXBadgeView.

public class AXBadgeView: UILabel {
  /// The attaching view of badge view.
  public final weak var attachingView: UIView!
  /// Limited number to show text on .number style. Default is 99.
  open var limitedNumber: Int = 99
  /// Override text as unavailable, using style instead.
  @available(*, unavailable)
  public final override var text: String? {
    get {
      return super.text
    }
    set { }
  }
  /// Style of badge view. Defaults to AXBadgeViewNormal.
  open var style = Style.normal {
    didSet {
      switch style {
      case .normal:
        super.text = nil
      case .new:
        super.text = "new"
      case .number(value: let val):
        if val > limitedNumber {
          super.text = "\(limitedNumber)"+"+"
        } else {
          super.text = "\(val)"
        }
      case .text(value: let val):
        super.text = val
      }
      
      sizeToFit()
      layer.cornerRadius = bounds.height/2
      layer.masksToBounds = true
      
      if !constraints.contains(_widthLayout) {
        addConstraint(_widthLayout)
      }
      if !constraints.contains(_heightLayout) {
        addConstraint(_heightLayout)
      }
      
      _widthLayout.constant = bounds.width
      _heightLayout.constant = bounds.height
      setNeedsLayout()
      
      if visible, scaleContent {
        show(animated: true)
      }
      
      if hideOnZero {
        switch style {
        case .number(value: let val) where val == 0:
          isHidden = true
        case .text(value: let val) where val.isEmpty:
          isHidden = true
        case .new: fallthrough
        default: break
        }
      } else {
        isHidden = false
      }
    }
  }
  /// Animation type of badge view. Defaults to None.
  open var animator = Animator.none {
    didSet {
      layer.removeAllAnimations()
      
      switch animator {
      case .breathing:
        layer.add(
          createBreathingAnimation(duration: 1.2),
          forKey: animator.rawValue
        )
      case .bounce:
        layer.add(
          createBounceAnimation(
            repeatCount: .greatestFiniteMagnitude,
            duration: 0.8,
            fromLayer: layer
          ),
          forKey: animator.rawValue
        )
      case .scale:
        layer.add(
          createScaleAnimation(
            fromScale: 1.2,
            toScale: 0.8,
            duration: 0.8,
            repeatCount: .greatestFiniteMagnitude
          ),
          forKey: animator.rawValue
        )
      case .shaking:
        layer.add(
          createShakeAnimation(
            repeatCount: .greatestFiniteMagnitude,
            duration: 0.8,
            fromLayer: layer
          ),
          forKey: animator.rawValue
        )
      default: break
      }
    }
  }
  /// The offsets of the badge view laying on the attaching view.
  /// Defaults to (x: .greatest, y: .least).
  open var offsets = Offsets(x: .greatest, y: .least) {
    didSet {
      if
        let suview = superview
      {
        if
          let _ = _horizontalLayout,
          suview.constraints.contains(_horizontalLayout)
        {
          superview?.removeConstraint(_horizontalLayout)
        }
        
        if
          let _ = _verticalLayout,
          suview.constraints.contains(_verticalLayout)
        {
          superview?.removeConstraint(_verticalLayout)
        }
        
        switch offsets.x {
        case .least, .exact(0.0):
          _horizontalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: suview,
            attribute: .left,
            multiplier: 1.0,
            constant: 0.0
          )
        case .greatest, .exact(suview.bounds.width):
          _horizontalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: suview,
            attribute: .right,
            multiplier: 1.0,
            constant: 0.0
          )
        case .exact(let val):
          _horizontalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: suview,
            attribute: .right,
            multiplier: val / suview.bounds.width,
            constant: 0.0
          )
        }
        
        switch offsets.y {
        case .least, .exact(0.0):
          _verticalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: suview,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0
          )
        case .greatest, .exact(suview.bounds.height):
          _verticalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: suview,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0
          )
        case .exact(let val):
          _verticalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: suview,
            attribute: .bottom,
            multiplier: val / suview.bounds.height,
            constant: 0.0
          )
        }
        
        superview?.addConstraint(_horizontalLayout)
        superview?.addConstraint(_verticalLayout)
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
      self.style = { style }()
    }
  }
  /// Scale content when set new content to badge label. Defaults to false.
  open var scaleContent = false
  /// Is badge visible.
  open var visible: Bool {
    return (superview != nil && !isHidden && alpha > 0) ? true : false
  }
  
  private var _horizontalLayout:  NSLayoutConstraint!
  private var _verticalLayout  :  NSLayoutConstraint!
  private lazy var _widthLayout = NSLayoutConstraint(
    item: self,
    attribute: .width,
    relatedBy: .equal,
    toItem: nil,
    attribute: .notAnAttribute,
    multiplier: 1,
    constant: 0
  )
  private lazy var _heightLayout = NSLayoutConstraint(
    item: self,
    attribute: .height,
    relatedBy: .equal,
    toItem: nil,
    attribute: .notAnAttribute,
    multiplier: 1,
    constant: 0
  )
  
  convenience init()
  {
    self.init(frame:CGRect.zero)
  }
  
  override init(
    frame: CGRect)
  {
    super.init(frame: frame)
    initializer()
  }
  
  required public init?(
    coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    initializer()
  }
  
  deinit {
    // Do something to dealloc.
  }
  
  /// Initializer.
  fileprivate func initializer() -> Void {
    translatesAutoresizingMaskIntoConstraints = false
    font = UIFont.systemFont(ofSize: 12)
    backgroundColor = UIColor.red
    textColor = UIColor.white
    textAlignment = NSTextAlignment.center
    style = .normal
  }
  /// - override: sizeThatFits
  override open func sizeThatFits(
    _ size: CGSize) -> CGSize
  {
    var susize = super.sizeThatFits(size)
    
    susize.width = max(susize.width + susize.height/2, minSize.width)
    susize.height = max(susize.height, minSize.height)
    return susize
  }
  /// - override: willMoveToSuperview
  override open func willMove(
    toSuperview newSuperview: UIView?)
  {
    super.willMove(toSuperview: newSuperview)
    
    if let _ = newSuperview {
      self.offsets = { offsets }()
    }
    alpha = 1.0
  }
  /// - override: didMoveToSuperview
  override open func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    if let suview = superview {
      
      self.offsets = { offsets }()
      
      if !suview.constraints.contains(_verticalLayout) {
        suview.addConstraint(_verticalLayout)
      }
      
      if !suview.constraints.contains(_horizontalLayout) {
        suview.addConstraint(_horizontalLayout)
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
  open func show(
    animated:Bool,
    inView view: UIView? = nil) -> Void
  {
    attachingView = view
    attachingView?.addSubview(self)
    
    isHidden    ? isHidden = false : ()
    alpha < 1.0 ? alpha = 1.0      : ()
    
    transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    
    if animated {
      UIView.animate(
        withDuration: 0.5,
        delay: 0.0,
        usingSpringWithDamping: 0.6,
        initialSpringVelocity: 0.6,
        options: AnimationOptions(rawValue: 7),
        animations: {
          self.transform = CGAffineTransform.identity
        },
        completion: nil
      )
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
  open func hide(
    animated: Bool,
    completion:(()->())? = nil) -> Void
  {
    if animated {
      UIView.animate(
        withDuration: 0.35,
        animations: {
          self.alpha = 0.0
        },
        completion: { [unowned self] finished -> Void in
          if finished {
            self.removeFromSuperview()
            self.alpha = 1.0
            completion?()
          }
        }
      )
    } else {
      self.removeFromSuperview()
      completion?()
    }
  }
}
