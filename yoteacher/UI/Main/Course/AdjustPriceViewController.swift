//
//  AdjustPriceViewController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-19.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class AdjustPriceViewController: UITableViewController, ResponseProtocol {
    
    var dataSource: NSMutableArray
    var dataSourceBuffer: NSMutableArray
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
        //dataSource.removeAllObjects()
        NetworkRequest.getMyTopics(UserInfoModelController.sharedInstance().token, start: nil, limit: nil, status: nil, responser: self)
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
        let identifier: NSString = NSString(string: "AdjustPriceCell")
        
        var cell: AdjustPriceTableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(identifier) as? AdjustPriceTableViewCell
        
        var cellData = dataSource.objectAtIndex(indexPath.row) as CourseContent
        
        var buttonTitle = "\(cellData.title) \(cellData.charge)RMB "
        if cellData.numOfTopics < 0 {
            buttonTitle += "Monthly"
        } else if cellData.numOfTopics > 1 {
            buttonTitle += "\(cellData.numOfTopics)Times"
        } else {
            buttonTitle += "\(cellData.duration)Min"
        }
        
        cell!.addjustPriceButton!.setTitle(buttonTitle, forState: UIControlState.Normal)
        cell!.id = cellData.id
        cell!.charge = cellData.charge
        cell!.duration = cellData.duration
        cell!.parentController = self
        //println(cellData.title)
        
        cell!.addjustPriceButton!.layer.borderWidth = 1
        cell!.addjustPriceButton!.layer.borderColor = UserSettings.sharedInstance().themeColor.CGColor
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func didReceiveError() {
        
    }
    
    func didReceiveError(error: NetworkRequestErrorType, action: NSString) {
        if action.isEqualToString(APIInfo.GetMyTopics) {
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
        if action.isEqualToString(APIInfo.GetMyTopics) {
            //print(data)
            let errno = data[JSONName.errno] as Int
            if errno != 0 {
                return
            }
            
            let result = data[JSONName.result] as NSMutableArray
            if result.count > 0 {
                //println(result)
                for obj in result {
                    var del = obj[JSONName.del] as Int
                    if del == 0 {
                        var title = obj[JSONName.title] as String
                        var id = obj[JSONName.id] as Int
                        var charge = obj[JSONName.charge] as Double
                        var duration = obj[JSONName.duration] as Int
                        var numoftopic = obj[JSONName.numoftopic] as Int
                        
                        var courseItem = CourseContent()
                        courseItem.title = title
                        courseItem.id = id
                        courseItem.charge = charge
                        courseItem.duration = duration
                        courseItem.numOfTopics = numoftopic
                        
                        dataSourceBuffer.addObject(courseItem)
                    }
                    
                    var tmp = dataSource
                    dataSource = dataSourceBuffer
                    dataSourceBuffer = NSMutableArray(array: dataSource, copyItems: true) // must conform to NSCopying
                    tmp.removeAllObjects()
                }
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
