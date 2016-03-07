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
        showsView.badgeView.animation = AXBadgeViewAnimation.Scale
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [unowned self]() -> Void in
            self.showsView.badgeView.offsets = CGPointMake(50, 0)
            self.showsView.badgeView.style = AXBadgeViewStyle.New
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [unowned self]() -> Void in
                self.heightConstant.constant += 50
                self.widthConstant.constant -= 50
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions(rawValue: 7), animations: { [unowned self]() -> Void in
                    self.view.layoutSubviews()
                    }, completion: {[unowned self](finished: Bool) -> Void in
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [unowned self]() -> Void in
                            self.heightConstant.constant -= 100
                            self.widthConstant.constant += 100
                            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions(rawValue: 7), animations: { [unowned self]() -> Void in
                                self.view.layoutSubviews()
                                }, completion:{[unowned self](finished: Bool) -> Void in
                                    self.showsView.badgeView.offsets = CGPointMake(CGFloat.max, CGFloat.min)
                                })
                        }
                    })
            }
        }
        // MARK: - Left bar button item.
        navigationItem.leftBarButtonItem?.showBadge(animated: true)
        navigationItem.leftBarButtonItem?.badgeView.animation = AXBadgeViewAnimation.Breathe
        navigationItem.leftBarButtonItem?.badgeView.style = AXBadgeViewStyle.Number
        navigationItem.leftBarButtonItem?.badgeView.text = "2"
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [unowned self]() -> Void in
            self.navigationItem.leftBarButtonItem?.badgeView.text = "3"
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [unowned self]() -> Void in
                self.navigationItem.leftBarButtonItem?.badgeView.text = "1000"
            }
        }
        
        // MARK: - Right bar button item.
        navigationItem.rightBarButtonItem?.showBadge(animated: true)
        navigationItem.rightBarButtonItem?.badgeView.offsets = CGPointMake(30, CGFloat.min)
        navigationItem.rightBarButtonItem?.badgeView.animation = AXBadgeViewAnimation.Bounce
        
        // MARK: - Tab bar item.
        navigationController?.tabBarItem?.badgeView.style = AXBadgeViewStyle.New
        navigationController?.tabBarItem?.badgeView.offsets = CGPointMake(view.bounds.width/4+10, 0)
        navigationController?.tabBarItem?.badgeView.animation = AXBadgeViewAnimation.Breathe
        navigationController?.tabBarItem?.showBadge(animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func badgeViewAction(sender: UIButton) {
        if showsView.badgeView.visible {
            showsView.clearBadge(animated: true)
            self.heightConstant.constant = 100
            self.widthConstant.constant = 100
        } else {
            showsView.showBadge(animated: true)
        }
    }
    
}