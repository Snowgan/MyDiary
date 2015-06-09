//
//  LockInfoView.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 1/6/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

class LockInfoView: UIView {

    var lockType: LockType?
    
    var itemsMargin: CGFloat {
        return self.bounds.width / 10
    }
    
    var itemRadius: CGFloat {
        return (self.bounds.width - 4 * self.itemsMargin) / 6
    }

    var passwd: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        if lockType! == LockType.CertifyPwdType {
            return
        }
        
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        defaultColor.setStroke()
        
        for i in 1...9 {
            // Number of column
            let colNo = (i - 1) / 3 + 1
            // Number of row
            let rowNo = (i % 3 == 0) ? 3 : i % 3
            
            let itemCenterPoint = CGPoint(x: colNo.f * itemsMargin + (2 * colNo - 1).f * itemRadius,
                                          y: rowNo.f * itemsMargin + (2 * rowNo - 1).f * itemRadius)
            let path = UIBezierPath(arcCenter: itemCenterPoint, radius: itemRadius, startAngle: 0, endAngle: (M_PI * 2).f, clockwise: true)

            if passwd.rangeOfString("\(i)") != nil {
                selectedColor.setStroke()
                path.stroke()
                defaultColor.setStroke()
            } else {
                path.stroke()
            }
            
        }
    }

    // Only be shown on the set passwd type
    func setupView() {
        switch lockType! {
        case .SetPwdType:
            break
        case .CertifyPwdType:
            var layer = CALayer()
            layer.frame = self.bounds
            layer.cornerRadius = self.bounds.width / 2
            layer.contents = UIImage(named: "YMD")?.CGImage
            layer.masksToBounds = true
            self.layer.addSublayer(layer)
        case .ModifyPwdType:
            break
        }
    }
}
