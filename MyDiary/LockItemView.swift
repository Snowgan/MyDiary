//
//  LockItemView.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 28/5/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

class LockItemView: UIView {

    let itemMargin = 2.0.f
    
    var outerCircleRadius: CGFloat {
        return self.bounds.width / 2 - itemMargin
    }
    var innerCircleRadius: CGFloat {
        return self.outerCircleRadius / 3
    }
    var sideLengthOfTriangle: CGFloat {
        return self.innerCircleRadius * 0.77
    }
    var selected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var direction: CGFloat = -1.f {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - Draw Method
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        setGraphicsProperty(context)
        
        drawOuterCirle(context, rect: rect)
        if selected {
            drawInnerCirle(context, rect: rect)
            if direction >= 0 {
                drawDirecTriangle(context, rect: rect)
            }
        }
    }
    
    func setGraphicsProperty(ctx: CGContextRef) {
        var color: CGColorRef
        if selected {
            color = selectedColor.CGColor
        } else {
            color = defaultColor.CGColor
        }
        CGContextSetStrokeColorWithColor(ctx, color)
        CGContextSetFillColorWithColor(ctx, color)
    }
    
    func drawOuterCirle(ctx: CGContextRef, rect: CGRect) {
        let centerPoint = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let path = UIBezierPath(arcCenter: centerPoint, radius: outerCircleRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = lineWidth
        path.stroke()
    }
    
    func drawInnerCirle(ctx: CGContextRef, rect: CGRect) {
        let centerPoint = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let path = UIBezierPath(arcCenter: centerPoint, radius: innerCircleRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.fill()
    }
    
    func drawDirecTriangle(ctx: CGContextRef, rect: CGRect) {
        CGContextSaveGState(ctx)
        
        CGContextTranslateCTM(ctx, rect.width / 2, rect.height / 2)
        let path = UIBezierPath()
        let pointA = CGPoint(x: innerCircleRadius * 1.5, y: -sideLengthOfTriangle * 0.5)
        let pointB = CGPoint(x: innerCircleRadius * 1.5, y: sideLengthOfTriangle * 0.5)
        let pointC = CGPoint(x: innerCircleRadius * 2.0, y: 0)
        path.moveToPoint(pointA)
        path.addLineToPoint(pointB)
        path.addLineToPoint(pointC)
        path.closePath()
        CGContextRotateCTM(ctx, self.direction)
        path.fill()
        
        CGContextRestoreGState(ctx)
    }

}
