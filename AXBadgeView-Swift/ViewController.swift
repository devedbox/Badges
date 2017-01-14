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
        showsView.badgeView.animation = AXBadgeViewAnimation.scale
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self]() -> Void in
            self.showsView.badgeView.offsets = CGPoint(x: 50, y: 0)
            self.showsView.badgeView.style = AXBadgeViewStyle.new
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self]() -> Void in
                self.heightConstant.constant += 50
                self.widthConstant.constant -= 50
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions(rawValue: 7), animations: { [unowned self]() -> Void in
                    self.view.layoutSubviews()
                    }, completion: {[unowned self](finished: Bool) -> Void in
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self]() -> Void in
                            self.heightConstant.constant -= 100
                            self.widthConstant.constant += 100
                            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions(rawValue: 7), animations: { [unowned self]() -> Void in
                                self.view.layoutSubviews()
                                }, completion:{[unowned self](finished: Bool) -> Void in
                                    self.showsView.badgeView.offsets = CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.leastNormalMagnitude)
                                })
                        }
                    })
            }
        }
        // MARK: - Left bar button item.
        navigationItem.leftBarButtonItem?.showBadge(animated: true)
        navigationItem.leftBarButtonItem?.badgeView.animation = AXBadgeViewAnimation.breathe
        navigationItem.leftBarButtonItem?.badgeView.style = AXBadgeViewStyle.number
        navigationItem.leftBarButtonItem?.badgeView.text = "2"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self]() -> Void in
            self.navigationItem.leftBarButtonItem?.badgeView.text = "3"
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [unowned self]() -> Void in
                self.navigationItem.leftBarButtonItem?.badgeView.text = "1000"
            }
        }
        
        // MARK: - Right bar button item.
        navigationItem.rightBarButtonItem?.showBadge(animated: true)
        navigationItem.rightBarButtonItem?.badgeView.offsets = CGPoint(x: 30, y: CGFloat.leastNormalMagnitude)
        navigationItem.rightBarButtonItem?.badgeView.animation = AXBadgeViewAnimation.bounce
        
        // MARK: - Tab bar item.
        navigationController?.tabBarItem?.badgeView.style = AXBadgeViewStyle.new
        navigationController?.tabBarItem?.badgeView.offsets = CGPoint(x: view.bounds.width/4+10, y: 0)
        navigationController?.tabBarItem?.badgeView.animation = AXBadgeViewAnimation.breathe
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
        if showsView.badgeView.visible {
            showsView.clearBadge(animated: true)
            self.heightConstant.constant = 100
            self.widthConstant.constant = 100
        } else {
            showsView.showBadge(animated: true)
        }
    }
    
}
