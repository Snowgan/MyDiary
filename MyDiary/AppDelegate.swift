//
//  AppDelegate.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 27/5/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = ContainerViewController.shareContainerVC
        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        ContainerViewController.shareContainerVC.isAuthentic = false
    }

    func applicationWillEnterForeground(application: UIApplication) {
        if !ContainerViewController.shareContainerVC.isAuthentic {
            ContainerViewController.shareContainerVC.doAuthenticWithType(LockType.CertifyPwdType)
        }
    }

}

