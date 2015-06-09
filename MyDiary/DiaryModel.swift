//
//  DiaryModel.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 6/6/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import Foundation
import CoreData

struct DiaryKey {
    static var id = "diaryid"
    static var text = "diarytext"
    static var time = "diarycreatetime"
    static var owner = "diaryownername"
    static var entityName = "DiaryEntityName"
}

typealias Diary = [String : AnyObject]

class DiaryManager {
    lazy var dataManageModel = DataManageModel.sharedDataManager
    lazy var defaults = NSUserDefaults.standardUserDefaults()
    
    /**
        Save a new diary item or update the exist diary item
    
        :param: content Diary text
        :param: existID Diary id if exist, or nil if new
        :param: complete Closure after save diary data
    */
    func saveDiaryContent(content: String, existID: Int?, complete: (Bool) -> Void) {
        let date = NSDate()
        var result: Bool
        var data: Diary = [DiaryKey.id : existID ?? createID(),
                         DiaryKey.text : content,
                         DiaryKey.time : date,
                        DiaryKey.owner : getSelfName()]
        if let id = existID {
            let fetchOption = ["predicate" : "\(DiaryKey.id) == \(id)"]
            result = dataManageModel.updateData(data, forEntityName: DiaryKey.entityName, withFetchOption: fetchOption)
        } else {
            result = dataManageModel.insertData(data, withEntityName: DiaryKey.entityName)
        }
        
        complete(result)
    }
    
    func deleteDiaryContentWithID(id: Int) {
        let fetchOption = ["predicate" : "\(DiaryKey.id) == \(id)"]
        dataManageModel.deleteDataForEntityName(DiaryKey.entityName, withFetchOption: fetchOption)
    }
    
    func seletedDiaryContentWithID(id: Int) -> Diary {
        let fetchOption = ["predicate" : "\(DiaryKey.id) == \(id)"]
        let results = dataManageModel.fetchDataForEntityName(DiaryKey.entityName, withFetchOption: fetchOption)
        return diaryObjFromObject(results!.last!)!
    }
    
    func fetchAllDiaries() -> [Diary] {
        var diaries = [Diary]()
        let sort = NSSortDescriptor(key: "\(DiaryKey.time)", ascending: false)
        let fetchOption = ["sortDescriptors" : [sort]]
        let results = dataManageModel.fetchDataForEntityName(DiaryKey.entityName, withFetchOption: fetchOption) as! [NSManagedObject]
        for result in results {
            let item = diaryObjFromObject(result)!
            diaries.append(item)
        }
        return diaries
    }
    
    func diaryObjFromObject(object: AnyObject) -> Diary? {
        var item: Diary?
        if let obj = object as? NSManagedObject {
            item = [DiaryKey.id : obj.valueForKey(DiaryKey.id)!,
                  DiaryKey.text : obj.valueForKey(DiaryKey.text)!,
                  DiaryKey.time : stringFromDate(obj.valueForKey(DiaryKey.time) as! NSDate),
                 DiaryKey.owner : obj.valueForKey(DiaryKey.owner)!]
        }
        return item
    }
    
    func createID() -> Int {
        var curID = defaults.integerForKey(DiaryKey.id)
        // If no records, create a new id from 1
        if curID == 0 {
            curID = 1
            defaults.setValue(curID, forKey: DiaryKey.id)
        } else {
            curID++
        }
        return curID
    }
    
    func getSelfName() -> String {
        return defaults.stringForKey(DiaryKey.owner) ?? "defaultName"
    }
    
    func stringFromDate(date: NSDate) -> String {
        let dateFotmatter = NSDateFormatter()
        dateFotmatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFotmatter.stringFromDate(date)
    }
}