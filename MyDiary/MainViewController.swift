//
//  MainViewController.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 4/6/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!

    var diaries = [Diary]()
    let diaryManager = DiaryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 100
        tableView.registerClass(DiaryListCell.self, forCellReuseIdentifier: "DiaryListCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        // Data
        diaries = diaryManager.fetchAllDiaries()
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryListCell") as! DiaryListCell
        let curDiary = diaries[indexPath.row]
        cell.diaryText.text = curDiary[DiaryKey.text] as? String
        cell.diaryDate.text = curDiary[DiaryKey.time] as? String
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowExistDiary", sender: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            diaryManager.deleteDiaryContentWithID(diaries[indexPath.row][DiaryKey.id] as! Int)
            diaries.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            break
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailVC = segue.destinationViewController as? DiaryDetailViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "AddNewDiary":
                        detailVC.isNew = true
                    case "ShowExistDiary":
                        detailVC.diaryDetail = diaries[tableView.indexPathForSelectedRow()!.row]
                    default: break
                }
            }
        }
    }
    

    
}
