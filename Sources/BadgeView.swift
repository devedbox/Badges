//
//  BadgeView.swift
//  Badge
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 devedbox.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

// MARK: - Types.

extension BadgeView {
  
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
    case percent(CGFloat)
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

// MARK: - BadgeViewDelegate.

public protocol BadgeViewDelegate {
  /// Badge view property.
  var badge: BadgeView { get set }
  /// Animated to show the badge view.
  func showBadge(animated: Bool)
  /// Animated to hide the badge view.
  func clearBadge(animated: Bool)
}

extension BadgeViewDelegate {
  public func showBadge(
    animated: Bool,
    configuration: (BadgeView) -> Void = { _ in })
  {
    configuration(badge)
    showBadge(animated: animated)
  }
}

// MARK: - UIView.

extension UIView: BadgeViewDelegate {
  /// The associated keys.
  private struct _AssociatedKeys {
    /// Key for `badgeView`.
    static var badge = "badgeKey"
  }
  /// Returns the badge view of the receiver.
  public var badge: BadgeView {
    get {
      if self is BadgeView {
        fatalError("The badge view of 'BadgeView' itself is not accessible.")
      }
      
      if let badge = objc_getAssociatedObject(self, &_AssociatedKeys.badge) as? BadgeView {
        return badge
      }
      
      let badge = BadgeView()
      objc_setAssociatedObject(
        self,
        &_AssociatedKeys.badge,
        badge,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
      return badge
    }
    
    set {
      if self is BadgeView {
        fatalError("The badge view of 'BadgeView' itself is not accessible.")
      }
      
      objc_setAssociatedObject(
        self,
        &_AssociatedKeys.badge,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  public func showBadge(
    animated: Bool) -> Void
  {
    badge.show(
      animated: animated,
      inView: self
    )
  }
  
  public func clearBadge(
    animated: Bool) -> Void
  {
    badge.hide(
      animated: animated
    )
  }
}

// MARK: - UIBarButtonItem.

extension UIBarButtonItem: BadgeViewDelegate {
  private struct _AssociatedKeys {
    static var badge = "badgeKey"
  }
  
  public var badge: BadgeView {
    get {
      if let badge = objc_getAssociatedObject(self, &_AssociatedKeys.badge) as? BadgeView {
        return badge
      }
      let badge = BadgeView()
      objc_setAssociatedObject(
        self, &_AssociatedKeys.badge,
        badge,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
      return badge
    }
    set {
      objc_setAssociatedObject(
        self,
        &_AssociatedKeys.badge,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  public func showBadge(
    animated: Bool) -> Void
  {
    guard let view = value(forKey: "view") as? UIView else {
      return
    }
    
    badge.show(
      animated: animated,
      inView: try! view.viewInEndpointsOfMinY()
    )
  }
  
  public func clearBadge(
    animated: Bool) -> Void
  {
    badge.hide(
      animated: animated
    )
  }
}

// MARK: - UITabBarItem.

extension UITabBarItem: BadgeViewDelegate {
  private struct _AssociatedKeys {
    static var badge = "badgeKey"
  }
  
  public var badge: BadgeView {
    get {
      if let badge = objc_getAssociatedObject(self, &_AssociatedKeys.badge) as? BadgeView {
        return badge
      }
      let badge = BadgeView()
      objc_setAssociatedObject(
        self,
        &_AssociatedKeys.badge,
        badge,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
      return badge
    }
    set {
      objc_setAssociatedObject(
        self,
        &_AssociatedKeys.badge,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  public func showBadge(
    animated: Bool) -> Void
  {
    guard let view = value(forKey: "view") as? UIView else {
      return
    }
    
    badge.show(
      animated: animated,
      inView: try! view.viewInEndpointsOfMinY()
    )
  }
  
  public func clearBadge(
    animated: Bool) -> Void
  {
    badge.hide(
      animated: animated
    )
  }
}

// MARK: - AXBadgeView.

public class BadgeView: UILabel {
  /// The mask of the badge view using shape layer.
  public struct Mask {
    /// The path content of the badge view's layer.
    public private(set) var path: (CGRect) -> CGPath

    public init(
      path: @escaping (CGRect) -> CGPath)
    {
      self.path = path
    }
    
    fileprivate func _layer(
      for frame: CGRect) -> CAShapeLayer
    {
      let layer = CAShapeLayer()
      layer.fillColor = UIColor.black.cgColor
      layer.path = path(frame)
      return layer
    }
    
    // MARK: Presets.
    
    public static let cornerRadius: Mask = Mask {
      return UIBezierPath(
        roundedRect: $0,
        cornerRadius: $0.height * 0.5
      ).cgPath
    }
    
    public static func roundingCorner(
      _ corner: UIRectCorner) -> Mask
    {
      return Mask {
        return UIBezierPath(
          roundedRect: $0,
          byRoundingCorners: corner,
          cornerRadii: CGSize(
            width: $0.height * 0.5,
            height: $0.height * 0.5
          )
        ).cgPath
      }
    }
  }
  /// The attaching view of badge view.
  public final weak var attachingView: UIView!
  /// The alignment view of badge view.
  public final weak var alignmentView: UIView!
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
  /// The mask of the badge view.
  public final var masking: Mask = .cornerRadius {
    didSet {
      setNeedsLayout()
    }
  }
  /// The stroke color of the badge view.
  open var strokeColor: UIColor? {
    didSet {
      setNeedsLayout()
    }
  }
  /// The stroke appearance layer.
  private lazy var _strokeLayer = CAShapeLayer()
  /// Style of badge view. Defaults to AXBadgeViewNormal.
  open var style = Style.normal {
    didSet {
      switch style {
      case .normal:
        super.text = ""
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
      
      if !constraints.contains(_widthLayout) {
        addConstraint(_widthLayout)
      }
      if !constraints.contains(_heightLayout) {
        addConstraint(_heightLayout)
      }
      
      _widthLayout.constant = bounds.width
      _heightLayout.constant = bounds.height
      setNeedsLayout()
      
      if
        visible,
        scaleContent
      {
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
        let suview = superview,
        let align = alignmentView ?? superview
      {
        if
          let _ = _horizontalLayout,
          suview.constraints.contains(_horizontalLayout)
        {
          suview.removeConstraint(_horizontalLayout)
        }
        
        if
          let _ = _verticalLayout,
          suview.constraints.contains(_verticalLayout)
        {
          suview.removeConstraint(_verticalLayout)
        }
        
        switch offsets.x {
        case .least, .exact(0.0), .percent(0.0):
          _horizontalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: align,
            attribute: .left,
            multiplier: 1.0,
            constant: 0.0
          )
        case .greatest, .exact(suview.bounds.width), .percent(1.0):
          _horizontalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: align,
            attribute: .right,
            multiplier: 1.0,
            constant: 0.0
          )
        case .exact(let val):
          _horizontalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: align,
            attribute: .right,
            multiplier: val / suview.bounds.width,
            constant: 0.0
          )
        case .percent(let val):
          _horizontalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: align,
            attribute: .right,
            multiplier: max(0.0, min(1.0, val)),
            constant: 0.0
          )
        }
        
        switch offsets.y {
        case .least, .exact(0.0), .percent(0.0):
          _verticalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: align,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0
          )
        case .greatest, .exact(suview.bounds.height), .percent(1.0):
          _verticalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: align,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0
          )
        case .exact(let val):
          _verticalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: align,
            attribute: .bottom,
            multiplier: val / suview.bounds.height,
            constant: 0.0
          )
        case .percent(let val):
          _verticalLayout = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: align,
            attribute: .bottom,
            multiplier: max(0.0, min(1.0, val)),
            constant: 0.0
          )
        }
        
        suview.addConstraint(_horizontalLayout)
        suview.addConstraint(_verticalLayout)
        suview.setNeedsDisplay()
      }
    }
  }
  /// Hide on zero content. Defaults to YES.
  open var hideOnZero = true
  /// Min size. Defaults to {12.0, 12.0}.
  open var minSize = CGSize(width: 12.0, height: 12.0) {
    didSet {
      sizeToFit()
      style = {
        style
      }()
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
    
    susize.width = max(susize.width + susize.height / 2, minSize.width)
    susize.height = max(susize.height, minSize.height)
    
    return susize
  }
  /// - override: layoutSubviews
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    _maskBadgeViewIfNeeded(with: masking)
    _strokeEdgesOfBadgeViewIfNeeded(with: strokeColor?.cgColor)
  }
  /// - override: willMoveToSuperview
  override open func willMove(
    toSuperview newSuperview: UIView?)
  {
    super.willMove(toSuperview: newSuperview)
    
    newSuperview.map { _ in
      offsets = {
        offsets
      }()
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
    inView attachingView: UIView? = nil,
    alignTo alignmentView: UIView? = nil) -> Void
  {
    self.attachingView = attachingView
    self.alignmentView = alignmentView ?? attachingView
    self.attachingView?.addSubview(self)
    
    self.attachingView?.clipsToBounds = false
    
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
    completion: @escaping (() -> Void) = { }) -> Void
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
            completion()
          }
        }
      )
    } else {
      self.removeFromSuperview()
      completion()
    }
  }
  /// Mask the bdage view if needed.
  private func _maskBadgeViewIfNeeded(
    with masking: Mask)
  {
    layer.mask = masking._layer(for: bounds)
  }
  /// Stroke the badge view's edges if needed.
  ///
  /// - Parameter strokeColor: The color of the strokes. Nil to ignore stroke.
  private func _strokeEdgesOfBadgeViewIfNeeded(
    with strokeColor: CGColor?)
  {
    if
      let strokeColor = strokeColor
    {
      _strokeLayer.frame = bounds
      _strokeLayer.path = masking.path(bounds.insetBy(dx: 0.5, dy: 0.5))
      _strokeLayer.strokeColor = strokeColor
      _strokeLayer.fillColor = nil
      _strokeLayer.strokeStart = 0.0
      _strokeLayer.strokeEnd = 1.0
      _strokeLayer.lineWidth = 1.0
      layer.addSublayer(_strokeLayer)
    } else {
      _strokeLayer.removeFromSuperlayer()
    }
  }
}
