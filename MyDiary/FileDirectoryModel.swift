//
//  File.swift
//  CoreLockBySwift
//
//  Created by Jennifer on 27/5/15.
//  Copyright (c) 2015 Jennifer. All rights reserved.
//

import Foundation

class FileDirectoryModel {
    
    static let fileManager = NSFileManager.defaultManager()
    
    // Get the url of documents directory
    func applicationDocumentsDirectory() -> NSURL {
        return FileDirectoryModel.searchUrlForDirectory(.DocumentDirectory)
    }
    
    // Get the url of catchs directory
    func applicationCatchsDirectory() -> NSURL {
        return FileDirectoryModel.searchUrlForDirectory(.CachesDirectory)
    }
    
    // Get the url of specified directory
    class func searchUrlForDirectory(directory: NSSearchPathDirectory) -> NSURL {
        let urls = fileManager.URLsForDirectory(directory, inDomains: .UserDomainMask) as! [NSURL]
        return urls[0]
    }
    
    // Create the specified directory
    func createDirectory(directory: String) -> Bool {
        var error: NSError?
        var success = false
        var isDir: ObjCBool = false
        let isExist = FileDirectoryModel.fileManager.fileExistsAtPath(directory, isDirectory: &isDir)
        if !(isExist && isDir) {
            success = FileDirectoryModel.fileManager.createDirectoryAtPath(directory, withIntermediateDirectories: true, attributes: nil, error: &error)
            if !success {
                println("Could not create the directory: \(directory) with error: \(error), \(error?.userInfo)")
            }
        }
        return success
    }
}