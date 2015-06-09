//
//  PasswdManager.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 4/6/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import Foundation

class PasswdManager {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let entityName = "Account"
    let attributeName = "passwd"
    
    func hasPwd() -> String? {
        return defaults.stringForKey(attributeName)
    }
    
    func savePwd(pwd: String) -> Bool {
        defaults.setObject(pwd, forKey: attributeName)
        return defaults.synchronize()
    }
    
    func deletePwd() -> Bool {
        defaults.removeObjectForKey(attributeName)
        return defaults.synchronize()
    }
}