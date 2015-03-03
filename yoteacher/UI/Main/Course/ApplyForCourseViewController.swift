//
//  ApplyForCourseViewController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-19.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class ApplyForCourseViewController: UITableViewController, ResponseProtocol {
    
    var dataSource: NSMutableArray
    var dataSourceBuffer: NSMutableArray
    var customCourseItem: CourseContent
    var lastRefreshTime: NSDate
    var isRefreshing: Bool
    var isLoadingMore: Bool
    //var dataLock: NSLock
    var start: Int
    var limit: Int
    
    required init(coder aDecoder: NSCoder) {
        self.dataSource = NSMutableArray()
        self.dataSourceBuffer = NSMutableArray()
        self.lastRefreshTime = NSDate()
        self.isRefreshing = false
        self.isLoadingMore = false
        //self.dataLock = NSLock()
        self.start = 0
        self.limit = UserInfoModelController.sharedInstance().limit
        
        self.customCourseItem = CourseContent()
        customCourseItem.title = "Custom"
        customCourseItem.id = 0
        customCourseItem.duration = 30
        customCourseItem.charge = 100
        customCourseItem.lang = 1
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.dataSource = NSMutableArray()
        self.dataSourceBuffer = NSMutableArray()
        self.lastRefreshTime = NSDate()
        self.isRefreshing = false
        self.isLoadingMore = false
        //self.dataLock = NSLock()
        self.start = 0
        self.limit = UserInfoModelController.sharedInstance().limit
        
        self.customCourseItem = CourseContent()
        customCourseItem.title = "Custom"
        customCourseItem.id = 0
        customCourseItem.duration = 30
        customCourseItem.charge = 100
        customCourseItem.lang = 1
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: Selector("refreshTable:"), forControlEvents: UIControlEvents.ValueChanged)
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Last Refresh: ")
        //self.lastRefreshTime = NSDate()
        //loadDataSource()
    }
    
    func refreshTable(sender: UIRefreshControl) {
        if (!isRefreshing) {
            self.isRefreshing = true
            //self.refreshControl.attributedTitle = NSAttributedString(string: "Last Refresh: ")
            self.reloadDataSource()
            self.lastRefreshTime = NSDate()
        }
        //self.refreshControl.endRefreshing()
    }
    
    func loadDataSource() {
        dataSource.removeAllObjects()
        NetworkRequest.getTopicTemplate(UserInfoModelController.sharedInstance().token, lang: 0, start: nil, limit: nil, responser: self)
    }
    
    func reloadDataSource() {
        self.dataSourceBuffer.removeAllObjects()
        self.loadDataSource()
    }
    
    func loadMoreDataSource() {
        if (!isLoadingMore) {
            self.isLoadingMore = true
            //self.loadMoreControll.beginRefreshing()
            start = dataSource.count
            self.loadDataSource()
        }
    }
    
    func releaseDataSource() {
        self.dataSource.removeAllObjects()
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: NSString = NSString(string: "ApplyForCourseCell")
        
        var cell: ApplyForCourseTabelViewCell? = self.tableView.dequeueReusableCellWithIdentifier(identifier) as? ApplyForCourseTabelViewCell
        
        var cellData = dataSource.objectAtIndex(indexPath.row) as CourseContent
        
        cell!.applyForCourseButton!.setTitle(cellData.title, forState: UIControlState.Normal)
        cell!.title = cellData.title
        cell!.content = cellData.content
        cell!.id = cellData.id
        cell!.charge = cellData.charge
        cell!.lang = cellData.lang
        cell!.classification = cellData.classification
        cell!.duration = cellData.duration
        //println(cellData.title)
        
        cell!.applyForCourseButton!.layer.borderWidth = 1
        cell!.applyForCourseButton!.layer.borderColor = UserSettings.sharedInstance().themeColor.CGColor
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func didReceiveError() {
        
    }
    
    func didReceiveError(error: NetworkRequestErrorType, action: NSString) {
        if action.isEqualToString(APIInfo.GetTopicTemplate) {
            if self.isLoadingMore {
                self.isLoadingMore = false
                //self.loadMoreControll.endRefreshing()
            }
            if self.isRefreshing {
                self.isRefreshing = false
                self.refreshControl!.endRefreshing()
            }
        }
    }
    
    func didReceiveResponse() {
        
    }
    
    func didReceiveResponse(data: NSDictionary, action: NSString) {
        if action.isEqualToString(APIInfo.GetTopicTemplate) {
            //print(data)
            let result = data[JSONName.result] as NSMutableArray
            if result.count > 0 {
                //println(result)
                dataSourceBuffer.removeLastObject()
                for obj in result {
                    var del = obj[JSONName.del] as Int
                    if del == 0 {
                        var courseItem = CourseContent()
                        courseItem.title = obj[JSONName.title] as String
                        courseItem.content = obj[JSONName.content] as String
                        courseItem.id = obj[JSONName.id] as Int
                        courseItem.charge = obj[JSONName.charge] as Double
                        courseItem.classification = obj[JSONName.classification] as Int
                        courseItem.duration = obj[JSONName.duration] as Int
                        
                        dataSourceBuffer.addObject(courseItem)
                    }
                }
                dataSourceBuffer.addObject(customCourseItem)
                
                var tmp = dataSource
                dataSource = dataSourceBuffer
                dataSourceBuffer = NSMutableArray(array: dataSource, copyItems: true) // must conform to NSCopying
                tmp.removeAllObjects()
            }
            
            if self.isLoadingMore {
                self.isLoadingMore = false
                //self.loadMoreControll.endRefreshing()
            }
            if self.isRefreshing {
                self.isRefreshing = false
                self.refreshControl!.endRefreshing()
            }
            self.tableView.reloadData()
        }
    }
}
