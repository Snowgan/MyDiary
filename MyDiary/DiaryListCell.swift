//
//  DiaryListCell.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 6/6/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

class DiaryListCell: UITableViewCell {
    
    var diaryText: UILabel!
    
    var diaryDate: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        diaryText = UILabel(frame: CGRect(x: 18, y: 20, width: screenBounds.width - 40, height: 40))
        diaryDate = UILabel(frame: CGRect(x: 18, y: 70, width: screenBounds.width - 40, height: 20))
        
        addSubview(diaryDate)
        addSubview(diaryText)

        backgroundColor = UIColor.clearColor()
        selectionStyle = UITableViewCellSelectionStyle.None
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = UIColor.clearColor()
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let drawRect = CGRectInset(rect, 3, 3)
        let path = UIBezierPath(roundedRect: drawRect, cornerRadius: 15.0)
        path.addClip()
        cellColorInSelected(selected)
        path.fill()
    }
    
    func cellColorInSelected(selected: Bool) {
        selected ? diaryTextSelectedColor.setFill() : diaryTextColor.setFill()
    }
}
