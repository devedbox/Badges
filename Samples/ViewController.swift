//
//  ViewController.swift
//  AXBadgeView-Swift
//
//  Created by ai on 16/2/24.
//  Copyright © 2016年 devedbox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var showsView: UIView!
  @IBOutlet weak var heightConstant: NSLayoutConstraint!
  @IBOutlet weak var widthConstant: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    showsView.showBadge(animated: true)
    showsView.badge.animator = .scale
    showsView.badge.masking = .roundingCorner([
      .topLeft,
      .bottomRight,
      .topRight
      ]
    )
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self]() -> Void in
      self.showsView.badge.offsets = .offsets(x: .exact(50.0), y: .exact(0.0))
      self.showsView.badge.style = .new
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self]() -> Void in
        self.heightConstant.constant += 50
        self.widthConstant.constant -= 50
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIView.AnimationOptions(rawValue: 7), animations: { [unowned self]() -> Void in
          self.view.layoutSubviews()
          }, completion: {[unowned self](finished: Bool) -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self]() -> Void in
              self.heightConstant.constant -= 100
              self.widthConstant.constant += 100
              UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIView.AnimationOptions(rawValue: 7), animations: { [unowned self]() -> Void in
                self.view.layoutSubviews()
                }, completion:{[unowned self](finished: Bool) -> Void in
                  self.showsView.badge.offsets = .offsets(x: .greatest, y: .least)
              })
            }
        })
      }
    }
    
    navigationController?.navigationBar.setNeedsLayout()
    navigationController?.navigationBar.layoutIfNeeded()
    
    // MARK: - Left bar button item.
    navigationItem.leftBarButtonItem?.showBadge(animated: true) {
      // $0.animator = .breathing
      $0.style = .number(value: 2)
      $0.masking = .roundingCorner([
        .topLeft,
        .bottomRight,
        .topRight
        ]
      )
    }
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self]() -> Void in
      self.navigationItem.leftBarButtonItem?.badge.style = .number(value: 3)
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self]() -> Void in
        self.navigationItem.leftBarButtonItem?.badge.style = .text(value: "1000")
      }
    }
    
    // MARK: - Right bar button item.
    navigationItem.rightBarButtonItem?.showBadge(animated: true)
    // navigationItem.rightBarButtonItem?.badgeView.offsets = .offsets(x: .exact(30.0), y: .least)
    navigationItem.rightBarButtonItem?.badge.animator = .shaking
    
    // MARK: - Tab bar item.
    navigationController?.tabBarItem?.badge.style = .new
    // navigationController?.tabBarItem?.badgeView.offsets = .offsets(x: .exact(view.bounds.width/4+10), y: .exact(0.0))
    navigationController?.tabBarItem?.badge.animator = .breathing
    navigationController?.tabBarItem?.showBadge(animated: true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func badgeViewAction(_ sender: UIButton) {
    if showsView.badge.visible {
      showsView.clearBadge(animated: true)
      self.heightConstant.constant = 100
      self.widthConstant.constant = 100
    } else {
      showsView.showBadge(animated: true)
    }
  }
}
