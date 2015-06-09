//
//  CommonFunction.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 29/5/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import Foundation
import UIKit

let screenBounds = UIScreen.mainScreen().bounds
let lineWidth = 2.0.f
//let selectedColor = rgb(34, 178, 246)
let selectedColor = rgb(219, 77, 109)
let defaultColor = rgb(241, 241, 241)
let bgColor = rgb(225, 107, 140)
let diaryTextColor = rgb(248, 195, 205)
let diaryTextSelectedColor = rgb(245, 150, 170)
let kSetPwdFirstMsg = "绘制解锁图案"
let kSetPwdSecondMsg = "请再次确认解锁图案"
let kSetPwdSecondWrongMsg = "输入有误，请重新确认"
let kSetPwdSuccessMsg = "您已成功设置密码"
let kCertifyPwdWrongMsg = "输入有误，请重新输入"
let kModifyPwdMsg = "请先输入原解锁图案"
let kSaveDiarySuccess = "保存成功"
let kSaveDiaryFailure = "保存失败，请重新保存"

func rgb(red: Float, green: Float, blue: Float) -> UIColor {
    return UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1)
}

func rgba(red: Float, green: Float, blue: Float, alpha: Float) -> UIColor {
    return UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(alpha))
}

extension Double {
    var f: CGFloat {
        return CGFloat(self)
    }
}

extension Int {
    var f: CGFloat {
        return CGFloat(self)
    }
}