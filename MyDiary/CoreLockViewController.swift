//
//  CoreLockViewController.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 29/5/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

/**
    Three types of Lock

    - SetPwdType: Set a new passwd
    - CertifyPwdType: Certify the passwd when login main view or before set a new passwd
    - ModifyPwdType: Modify the original passwd
*/
enum LockType: Int {
    case SetPwdType = 0
    case CertifyPwdType
    case ModifyPwdType
}

@objc
protocol CoreLockViewControllerDelegate {
    optional func certifyPwdComplete()
    optional func setPwdComplete(pwd: String)
}


class CoreLockViewController: UIViewController, LockInputDelegate {

    @IBOutlet weak var lockInputView: LockForInputView!
    @IBOutlet weak var lockInfoView: LockInfoView!
    @IBOutlet weak var lockMsgLabel: LockMessageLabel!
    
    /// Core lock's delegate
    weak var delegate: CoreLockViewControllerDelegate?
    
    /// The type of Lock
    var lockType: LockType!
    
    /// The original passwd
    var passwd: String?
    
    let pwdManager = PasswdManager()
    
    // MARK: - Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = bgColor
        lockInputView.backgroundColor = UIColor.clearColor()
        lockInfoView.backgroundColor = UIColor.clearColor()
        lockInfoView.lockType = self.lockType
        
        // Set lockInputView's delegate
        lockInputView.delegate = self
        
        switch self.lockType! {
        case LockType.SetPwdType:
            lockMsgLabel.setMessageText(kSetPwdFirstMsg)
        case LockType.CertifyPwdType:
            break
        case LockType.ModifyPwdType:
            lockMsgLabel.setMessageText(kModifyPwdMsg)
        }
        
        
        
    }
    
    // Add each lock item after view layout, otherwith the items' position is wrong
    override func viewDidAppear(animated: Bool) {
        lockInputView.addLockItems()
        lockInfoView.setupView()
    }
    
    // MARK: - LockInput Delegate Methods
    
    func getOldPwd() -> String? {
        return self.passwd ?? pwdManager.hasPwd()
//        return passwd!.isEmpty ? pwdManager.hasPwd() : passwd
    }
    
    func setPwd(pwd: String, atStep step: Int, isSuccess state: Bool) {
        if step == 1 {
            lockMsgLabel.setMessageText(kSetPwdSecondMsg)
            lockInfoView.passwd = pwd
        } else if step == 2 {
            state ? setPwdSuccessHandle(pwd) : lockMsgLabel.setMessageText(kSetPwdSecondWrongMsg)
        }
    }
    
    func certifyPwd(pwd: String, isSuccess state: Bool) {
        state ? certifyPwdSuccessHandle() : lockMsgLabel.setMessageText(kCertifyPwdWrongMsg)
    }
    
    func modifyPwd(pwd: String, isSuccess state: Bool) {
        state ? modifyPwdHandle() : lockMsgLabel.setMessageText(kCertifyPwdWrongMsg)
    }

    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientationMask.Portrait.rawValue.hashValue
    }
    
    func setPwdSuccessHandle(pwd: String) {
        pwdManager.savePwd(pwd)
        delegate?.setPwdComplete?(pwd)
    }
    
    func certifyPwdSuccessHandle() {
        delegate?.certifyPwdComplete?()
    }
    
    // At the modify type, first certify the old passwd. Then into the set passwd type
    func modifyPwdHandle() {
        lockMsgLabel.setMessageText(kSetPwdFirstMsg)
        self.lockType = LockType.SetPwdType
    }
    
    deinit {
        println("\(__FUNCTION__)")
    }
    
}
