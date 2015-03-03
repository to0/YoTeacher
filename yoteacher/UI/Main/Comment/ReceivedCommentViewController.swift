//
//  ReceivedCommentViewController.swift
//  yoteacher
//
//  Created by Park006 on 14-7-27.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class ReceivedCommentViewController: UITableViewController, ResponseProtocol {
    
    var dataSource: NSMutableArray
    var dataSourceBuffer: NSMutableArray
    var placeholderImage: UIImage
    var lastRefreshTime: NSDate
    var isRefreshing: Bool
    var isLoadingMore: Bool
    var dataLock: NSLock
    var start: Int
    var limit: Int
    //var loadMoreControll: UIRefreshControl
    
    required init(coder aDecoder: NSCoder) {
        self.dataSource = NSMutableArray()
        self.dataSourceBuffer = NSMutableArray()
        self.placeholderImage = UIImage(named: "comment_avatar")!
        self.lastRefreshTime = NSDate()
        self.isRefreshing = false
        self.isLoadingMore = false
        self.dataLock = NSLock()
        self.start = 0
        self.limit = UserInfoModelController.sharedInstance().limit
        //self.loadMoreControll = UIRefreshControl()
        UIKeyInputDownArrow
        super.init(coder: aDecoder)
    }
 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.dataSource = NSMutableArray()
        self.dataSourceBuffer = NSMutableArray()
        self.placeholderImage = UIImage(named: "comment_avatar")!
        self.lastRefreshTime = NSDate()
        self.isRefreshing = false
        self.isLoadingMore = false
        self.dataLock = NSLock()
        self.start = 0
        self.limit = UserInfoModelController.sharedInstance().limit
        //self.loadMoreControll = UIRefreshControl()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: Selector("refreshTable:"), forControlEvents: UIControlEvents.ValueChanged)
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Last Refresh: ")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableFooterView!.backgroundColor = UIColor.clearColor()
        //self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height - self.tableView.frame.origin.y)
        //self.loadDataSource()
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
    
    func reloadDataSource() {
        self.start = 0
        self.limit = UserInfoModelController.sharedInstance().limit
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
    
    func loadDataSource() {
        NetworkRequest.getTeacherEvaluations(UserInfoModelController.sharedInstance().uid, start: self.start, limit: self.limit, responser: self)
    }
    
    func releaseDataSource() {
        self.dataSource.removeAllObjects()
        self.tableView.reloadData()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            self.loadMoreDataSource()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: NSString = NSString(string: "ReceivedCommentsCell")
        
        var cell: ReceivedCommentsTableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(identifier) as? ReceivedCommentsTableViewCell
        /*
        if (indexPath.row >= dataSource.count) {
            println("cell \(indexPath.row) of \(dataSource.count)")
            println("index out of range")
            return cell
        }*/
        
        var cellData = dataSource.objectAtIndex(indexPath.row) as StudentComments
        
        cell!.commentLabel!.text = cellData.content
        cell!.scoreLabel!.text = "Score: \(cellData.score)"
        var range = cellData.createTime.rangeOfString("T") 
        var aRange: Range = Range(start: cellData.createTime.startIndex, end: range!.startIndex)
        cell!.timeLabel!.text = cellData.createTime.substringWithRange(aRange)
        
        if cell!.avatarImageButton!.imageURL == nil || !cell!.avatarImageButton!.imageURL.isEqual(NSURL(string: "\(APIInfo.SERVER)\(cellData.avatar)"))  {
            //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            cell!.avatarImageButton!.placeholderImage = self.placeholderImage
            cell!.avatarImageButton!.imageURL = NSURL(string: "\(APIInfo.SERVER)\(cellData.avatar)")
            cell!.avatarImageButton!.layer.masksToBounds = true
            cell!.avatarImageButton!.layer.cornerRadius = cell!.avatarImageButton!.frame.width / 2
            //println(cell!.avatarImageButton!.imageURL.absoluteString)
            //})
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count > 0 {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        } else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        return dataSource.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func didReceiveError() {
        
    }
    
    func didReceiveError(error: NetworkRequestErrorType, action: NSString) {
        if action.isEqualToString(APIInfo.GetTeacherEvaluations) {
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
        if action.isEqualToString(APIInfo.GetTeacherEvaluations) {
            //print(data)
            let result = data[JSONName.result] as NSMutableArray
            if result.count > 0 {
                //println(result)
                //println("before loading: data--\(dataSource.count) / buffer--\(dataSourceBuffer.count)")
                for obj in result {
                    var del = obj[JSONName.del] as Int
                    if del == 0 {
                        var stuAvatar = obj[JSONName.avatar] as String
                        var name = obj[JSONName.username] as String
                        var createTime = obj[JSONName.createTime] as String
                        var content = obj[JSONName.content] as String
                        //var mid = obj[JSONName.id] as String
                        var score = obj[JSONName.score] as Float

                        var commentItem = StudentComments(avatar: stuAvatar, username: name, content: content, createTime: createTime, score: score)
                        dataSourceBuffer.addObject(commentItem)
                        //dataSource.addObject(commentItem)
                    }
                }
                
                dataLock.lock() // no meaning here now!
                var tmp = dataSource
                dataSource = dataSourceBuffer
                dataSourceBuffer = NSMutableArray(array: dataSource, copyItems: true) // must conform to NSCopying
                tmp.removeAllObjects()
                dataLock.unlock()
                
                //println("after loading: \(dataSource.count) / buffer--\(dataSourceBuffer.count)")
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
