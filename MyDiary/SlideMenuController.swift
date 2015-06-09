//
//  SlideMenuController.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 6/6/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

@objc
protocol SlideMenuDelegate {
    optional func showSettingVCAtIndex(index: Int)
}

class SlideMenuController: UITableViewController {

    var containerDelegate: SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .None
    }

    override func viewDidAppear(animated: Bool) {
        
        // Header View
        let headerFrame = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height / 4)
        tableView.tableHeaderView = SelfImageInfoView(frame: headerFrame)
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "SettingMenuCell")
        
        cell.imageView?.image = UIImage(named: "settingIcon")
        cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        cell.textLabel?.text = "手势密码管理"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        containerDelegate?.showSettingVCAtIndex?(indexPath.row)
    }

}
