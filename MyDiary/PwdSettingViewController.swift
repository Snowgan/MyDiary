//
//  PwdSettingViewController.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 7/6/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

class PwdSettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var isNeedPws = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    let pwdSwitch = UISwitch()
    let pwdManager = PasswdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "dismissSettingNavi")
        if pwdManager.hasPwd() != nil {
            isNeedPws = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.row == 0 {
            pwdSwitch.on = isNeedPws
            cell.addSubview(pwdSwitch)
            pwdSwitch.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
            pwdSwitch.setTranslatesAutoresizingMaskIntoConstraints(false)
            var centerY = NSLayoutConstraint(item: pwdSwitch, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            cell.addConstraint(centerY)
            var trailing = NSLayoutConstraint(item: cell, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: pwdSwitch, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 20)
            cell.addConstraint(trailing)
            cell.textLabel?.text = "是否使用手势密码"
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.text = "修改手势密码"
            if !isNeedPws { cell.selectionStyle = .Gray }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row == 1 && pwdSwitch.on == false {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            performSegueWithIdentifier("ModifyPwdToCoreLock", sender: nil)
        }
    }
    
    func dismissSettingNavi() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func switchChanged(sender: UISwitch) {
        if sender.on == true {
            isNeedPws = true
            performSegueWithIdentifier("SettingPwdToCoreLock", sender: nil)
        } else {
            isNeedPws = false
            pwdManager.deletePwd()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let lockVC = segue.destinationViewController as? CoreLockViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "SettingPwdToCoreLock":
                    lockVC.lockType = LockType.SetPwdType
                    lockVC.delegate = ContainerViewController.shareContainerVC
                case "ModifyPwdToCoreLock":
                    lockVC.lockType = LockType.ModifyPwdType
                    lockVC.delegate = ContainerViewController.shareContainerVC
                default:
                    break
                }
            }
        }
    }
    
}
