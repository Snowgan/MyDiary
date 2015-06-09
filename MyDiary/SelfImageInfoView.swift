//
//  SelfImageInfoView.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 7/6/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

class SelfImageInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        var layer = CALayer()
        let layerWH = (center.x > center.y ? bounds.height : bounds.width) - 70
        let layerOrigin = CGPoint(x: center.x - layerWH / 2, y: center.y - layerWH / 2)
        layer.frame = CGRect(origin: layerOrigin, size: CGSize(width: layerWH, height: layerWH))
        layer.cornerRadius = layerWH / 2
        layer.contents = UIImage(named: "YMD")?.CGImage
        layer.masksToBounds = true
        self.layer.addSublayer(layer)
    }

}
