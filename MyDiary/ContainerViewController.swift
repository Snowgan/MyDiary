//
//  ContainerViewController.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 6/6/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, CoreLockViewControllerDelegate, SlideMenuDelegate {
    
    /// Singleton container instance to control the transition between children view controller
    static let shareContainerVC = ContainerViewController()
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        view = UIView()
    }
    
    /// Check whether need passed certify
    var isAuthentic = false
    
    var slideMenuVC: SlideMenuController?
    
    var mainTabBarC: UITabBarController!
    
    var pwdManager: PasswdManager!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainer()
    }

    override func viewDidAppear(animated: Bool) {
        if !isAuthentic {
            doAuthenticWithType(LockType.CertifyPwdType)
        }
    }
    
    func setupContainer() {
        mainTabBarC = UIStoryboard.getMainTabBarC()
        pwdManager = PasswdManager()
        
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "slideInHandle:")
        edgePanGesture.edges = .Left
        mainTabBarC.view.addGestureRecognizer(edgePanGesture)
    }

    func doAuthenticWithType(type: LockType) {
        if let pwd = pwdManager.hasPwd() {
            let coreLockVC = UIStoryboard.getCoreLockVC()
            if let lockVC = coreLockVC {
                lockVC.delegate = self
                lockVC.lockType = type
                lockVC.passwd = pwd
                presentViewController(lockVC, animated: false, completion: nil)
            }
        } else {
            addChildVC(mainTabBarC)
        }
    }

    // MARK: - Core Lock View Controller delegate
    
    func certifyPwdComplete() {
        isAuthentic = true
        self.dismissViewControllerAnimated(true, completion: nil)
        addChildVC(mainTabBarC)
    }
    
    func setPwdComplete(pwd: String) {
        isAuthentic = true
        let alert = UIAlertView(title: nil, message: kSetPwdSuccessMsg, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Slide Menu delegate
    
    func showSettingVCAtIndex(index: Int) {
        let settingNavi = UIStoryboard.getSettingVC()!
        
        UIView.animateWithDuration(0.2, animations: {
            self.slideMenuVC?.view.frame.origin.x = -self.view.bounds.width / 2
            self.mainTabBarC.view.frame.origin.x = 0
            self.mainTabBarC.view.subviews.last?.removeFromSuperview()
            }, completion: {
                (success) in
                self.removeChildVC(self.slideMenuVC!)
                self.slideMenuVC = nil
                self.presentViewController(settingNavi, animated: true, completion: nil)
        })
    }
    
    // MARK: - Child View Controller Management
    
    func addChildVC(vc: UIViewController, withFrame frame: CGRect = screenBounds) {
        vc.view.frame = frame
        view.addSubview(vc.view)
        addChildViewController(vc)
        vc.didMoveToParentViewController(self)
    }
    
    func removeChildVC(vc: UIViewController) {
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    func slideInHandle(gesture: UIScreenEdgePanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            slideMenuVC = SlideMenuController()
            slideMenuVC!.containerDelegate = self
            let slidePanGesture = UIPanGestureRecognizer(target: self, action: "slideOutHandle:")
            slideMenuVC?.view.addGestureRecognizer(slidePanGesture)
            let slideMenuFrame = CGRect(x: -view.bounds.width / 2, y: 0, width: view.bounds.width / 2, height: view.bounds.height)
            addChildVC(slideMenuVC!, withFrame: slideMenuFrame)
            
            let grayView = UIView(frame: mainTabBarC.view.bounds)
            grayView.backgroundColor = UIColor.blackColor()
            grayView.alpha = 0
            mainTabBarC.view.addSubview(grayView)
            UIView.animateWithDuration(0.5, animations: {
                grayView.alpha = 0.6
            })
        case .Changed:
            let translation = gesture.translationInView(mainTabBarC.view)
            if slideMenuVC?.view.frame.origin.x < 0 {
                slideMenuVC?.view.frame.origin.x += translation.x
                mainTabBarC.view.frame.origin.x += translation.x
            }
            gesture.setTranslation(CGPointZero, inView: mainTabBarC.view)
        case .Ended:
            if slideMenuVC?.view.frame.origin.x < 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    self.slideMenuVC?.view.frame.origin.x = 0
                    self.mainTabBarC.view.frame.origin.x = self.view.bounds.width / 2
                }, completion: nil)
            }
        case .Cancelled:
            break
        default:
            break
        }
    }
    
    func slideOutHandle(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began: fallthrough
        case .Changed:
            let translation = gesture.translationInView(slideMenuVC!.view)
            if slideMenuVC?.view.frame.origin.x > -view.bounds.width / 2 && translation.x < 0 {
                slideMenuVC?.view.frame.origin.x += translation.x
                mainTabBarC.view.frame.origin.x += translation.x
            }
            gesture.setTranslation(CGPointZero, inView: mainTabBarC.view)
        case .Ended:
            if slideMenuVC?.view.frame.origin.x > -view.bounds.width / 2 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                    self.slideMenuVC?.view.frame.origin.x = -self.view.bounds.width / 2
                    self.mainTabBarC.view.frame.origin.x = 0
                    (self.mainTabBarC.view.subviews.last as! UIView).alpha = 0
                    }, completion: {
                    (success) in
                    self.removeChildVC(self.slideMenuVC!)
                    self.mainTabBarC.view.subviews.last?.removeFromSuperview()
                    self.slideMenuVC = nil
                })
            }
        case .Cancelled:
            break
        default:
            break
        }
    }

}

private extension UIStoryboard {
    static let mainStoryBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    
    class func getCoreLockVC() -> CoreLockViewController? {
        return mainStoryBoard.instantiateViewControllerWithIdentifier("CoreLockVC") as? CoreLockViewController
    }
    
    class func getMainTabBarC() -> UITabBarController? {
        return mainStoryBoard.instantiateViewControllerWithIdentifier("MainTabBarVC") as? UITabBarController
    }
    
    class func getSettingVC() -> UINavigationController? {
        return mainStoryBoard.instantiateViewControllerWithIdentifier("SettingMenuVC") as? UINavigationController
    }
}
