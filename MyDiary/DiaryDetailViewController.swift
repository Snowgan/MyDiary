//
//  DiaryDetailViewController.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 6/6/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import UIKit

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var diaryText: UITextView!
    let diaryManager = DiaryManager()
    
    var isNew = false
    
    var diaryDetail: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        diaryText.editable = isNew
        diaryText.backgroundColor = UIColor.whiteColor()
        
        view.backgroundColor = UIColor.whiteColor()
        var navigationBarItems = [UIBarButtonItem]()
        if isNew {
            navigationItem.title = "New Diary"
        } else {
            diaryText.text = diaryDetail![DiaryKey.text] as! String
            let editBarItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editContent")
            navigationBarItems.append(editBarItem)
        }
        let saveBarItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveDiary:")
        navigationBarItems.append(saveBarItem)
        navigationItem.rightBarButtonItems = navigationBarItems
    }
    
    func saveDiary(sender: UIBarButtonItem) {
        var id: Int? = isNew ? nil : (diaryDetail![DiaryKey.id] as! Int)
        diaryManager.saveDiaryContent(diaryText.text, existID: id) {
            [unowned self] (success: Bool) in
            self.diaryText.resignFirstResponder()
            var msg = success ? kSaveDiarySuccess : kSaveDiaryFailure
            let alert = UIAlertView(title: nil, message: msg, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        isNew = false
    }
    
    func editContent() {
        diaryText.editable = true
    }

}
