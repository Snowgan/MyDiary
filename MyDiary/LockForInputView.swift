//
//  LockForInputView.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 28/5/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

protocol LockInputDelegate: class {
    /// The type of Lock
    var lockType: LockType! { get set }
    
    /**
        Get the old passwd
    
        :returns: The passwd string
    */
    func getOldPwd() -> String?
    
    /** 
        Set passwd delegate. At the SetPwdType, two step is necessary. First step input new passwd, second step to confirm
    
        :param: pwd The latest input passwd
        :param: atStep The current step(1 or 2)
        :param: isSuccess Whether set passwd process is success
    */
    func setPwd(pwd: String, atStep step: Int, isSuccess state: Bool)
    
    /**
        Modify passwd delegate
    
        :param: pwd The input passwd
        :param: isSuccess Whether the first certify passwd process is success
    */
    func modifyPwd(pwd: String, isSuccess state: Bool)
    
    /**
        Certify passwd delegate
    
        :param: pwd The input passwd
        :param: isSuccess Whether input the right passwd
    */
    func certifyPwd(pwd: String, isSuccess state: Bool)
}

class LockForInputView: UIView {

    weak var delegate: LockInputDelegate?

    /// Margin between lock items and borders
    var itemsMargin: CGFloat {
        return self.bounds.width / 10
    }
    
    /// Lock items width = height
    var itemWH: CGFloat {
        return (self.bounds.width - 4 * self.itemsMargin) / 3
    }
    
    /// Array for nine lock item
    var lockItemsArray = [LockItemView]()
    
    /// Array for selected lock item
    var selectedLockItemArray = [LockItemView]()
    
    /// The latest input Passwd string
    var pwd = ""
    /// Temporarily store the first input passwd
    var tmpPwd: String?
    
    /// Array for touch point after first active one lock item
    var touchPointArray = [CGPoint]()
    /// The current touch point
    var curPoint: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Subviews layout
    /// Add lock items to the input view
    func addLockItems() {
        
        // Initial each lock item
        for i in 1...9 {
            /// Number of column
            let colNo = (i - 1) / 3 + 1
            /// Number of row
            let rowNo = (i % 3 == 0) ? 3 : i % 3
            /// Lock item's position
            let itemFrame = CGRect(x: colNo.f * itemsMargin + (colNo - 1).f * itemWH,
                y: rowNo.f * itemsMargin + (rowNo - 1).f * itemWH,
                width: itemWH,
                height: itemWH)
            
            let lockItemView = LockItemView(frame: itemFrame)
            lockItemView.backgroundColor = UIColor.clearColor()
            // Set unique tag for passwd
            lockItemView.tag = i
            
            self.addSubview(lockItemView)
            lockItemsArray.append(lockItemView)
        }

    }
    
    
    // MARK: - Draw Method
    
    override func drawRect(rect: CGRect) {
        if selectedLockItemArray.count == 0 {
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        
        // Clip lock items range
        CGContextAddRect(context, rect)
        for item in lockItemsArray {
            CGContextAddEllipseInRect(context, item.frame)
        }
        CGContextEOClip(context)
        
        drawLinesBetweenItems()
    }
    
    /// Draw lines of finger moved between lock items.
    func drawLinesBetweenItems() {
        let path = UIBezierPath()
        if touchPointArray.count != 0 {
            path.moveToPoint(touchPointArray.first!)
            for i in 1..<touchPointArray.count {
                path.addLineToPoint(touchPointArray[i])
            }
            if curPoint != nil {
                path.addLineToPoint(curPoint!)
            }
        }
        path.lineWidth = lineWidth
        path.lineCapStyle = kCGLineCapRound
        selectedColor.setStroke()
        path.stroke()
    }
    
    // MARK: - Touch Handles
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        clearSelectedStatus()
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touchLocation = (touches.first as! UITouch).locationInView(self)
    
        if !isLocatedInLockItem(touchLocation) {
            curPoint = touchLocation
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("\(pwd)")
        curPoint = nil
        touchEndedHandle()
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        clearSelectedStatus()
        setNeedsDisplay()
    }
    
    /// Handle action according to lock type when touch event ended.
    func touchEndedHandle() {
        var success = false
        if let lockType = delegate?.lockType {
            switch lockType {
            case .SetPwdType:
                var step = 2
                if tmpPwd == nil {
                    tmpPwd = pwd
                    step = 1
                } else if pwd == tmpPwd {
                    success = true
                } 
                clearSelectedStatus()
                delegate?.setPwd(tmpPwd!, atStep: step, isSuccess: success)
            case .CertifyPwdType:
                if pwd == delegate?.getOldPwd() {
                    success = true
                } else {
                    clearSelectedStatus()
                }
                delegate?.certifyPwd(pwd, isSuccess: success)
            case .ModifyPwdType:
                if pwd == delegate?.getOldPwd() {
                    success = true
                }
                clearSelectedStatus()
                delegate?.modifyPwd(pwd, isSuccess: success)
            }
        }
    }
    
    // MARK: - Costom Method
    /**
        Returns whether a touch finger is located in a certain lock item.
    
        :param: location The position of a touch finger
        :returns: true if the touch finger is located in a certain lock item
    */
    func isLocatedInLockItem(location: CGPoint) -> Bool {
        var isLocated = false
        for itemView in lockItemsArray {
            if !CGRectContainsPoint(itemView.frame, location) {
                continue
            } else {
                if selectedLockItemArray.count > 0 {
                    // If the itemView is selected, no action to do
                    if contains(selectedLockItemArray, itemView) {
                        break
                    }
                    
                    // Calculate the privious lock item's direction
                    let preLockItem = selectedLockItemArray.last!
                    let preDirection = directionFromPoint(preLockItem.frame.origin, toPoint: itemView.frame.origin)
                    preLockItem.direction = preDirection
                }
                
                selectedLockItemArray.append(itemView)
                // Record the current lock item view's tag as one of passwd
                pwd += "\(itemView.tag)"
                
                itemView.selected = true
                isLocated = true
                touchPointArray.append(itemView.center)
                curPoint = itemView.center
                
                break
            }
        }
        
        return isLocated
    }
    
    /**
        Calculate the direction between the two selected lock items
    
        :param: prePoint The previous selected lock item
        :param: toPoint The later selected lock item
        :returns: returns the direction in radians
    */
    func directionFromPoint(prePoint: CGPoint, toPoint nextPoint: CGPoint) -> CGFloat {
        var direction = 0.f
        
        if prePoint.y < nextPoint.y {
            direction = atan((prePoint.x - nextPoint.x) / (nextPoint.y - prePoint.y)) + M_PI_2.f
        } else if prePoint.y > nextPoint.y {
            direction = -atan((prePoint.x - nextPoint.x) / (prePoint.y - nextPoint.y)) + M_PI_2.f * 3
        } else {
            direction = (prePoint.x - nextPoint.x) > 0 ? M_PI.f : 0
        }
        
        return direction
    }
    
    /// Clear all selected status of lock items and touch point record
    func clearSelectedStatus() {
        for item in selectedLockItemArray {
            item.selected = false
            item.direction = -1.f
            pwd = ""
        }
        selectedLockItemArray.removeAll(keepCapacity: false)
        touchPointArray.removeAll(keepCapacity: false)
        
        setNeedsDisplay()
    }
    
}
