//
//  MyCommentViewController.swift
//  yoteacher
//
//  Created by Park006 on 14-7-27.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class MyCommentViewController: UITableViewController, ResponseProtocol {
    
    var dataSource: NSMutableArray
    var dataSourceBuffer: NSMutableArray
    var placeholderImage: UIImage
    var lastRefreshTime: NSDate
    var isRefreshing: Bool
    var isLoadingMore: Bool
    //var dataLock: NSLock
    var start: Int
    var limit: Int
    
    //@IBOutlet strong var pullTableView: PullTableView
    
    required init(coder aDecoder: NSCoder) {
        self.dataSource = NSMutableArray()
        self.dataSourceBuffer = NSMutableArray()
        self.placeholderImage = UIImage(named: "comment_avatar")!
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
        self.placeholderImage = UIImage(named: "comment_avatar")!
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
        self.lastRefreshTime = NSDate()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableFooterView!.backgroundColor = UIColor.clearColor()
        //self.loadDataSource()
    }

    func refreshTable(sender: UIRefreshControl) {
        if !isRefreshing {
            //self.refreshControl.attributedTitle = NSAttributedString(string: "Last Refresh: ")
            self.isRefreshing = true
            self.reloadDataSource()
            self.refreshControl!.endRefreshing()
            self.lastRefreshTime = NSDate()
        }
    }
    
    func reloadDataSource() {
        self.dataSourceBuffer.removeAllObjects()
        self.loadDataSource()
    }
    
    func loadDataSource() {
        NetworkRequest.getTakeMissions(UserInfoModelController.sharedInstance().token, uid: UserInfoModelController.sharedInstance().uid, start: nil, limit: nil, responser: self)
        //NetworkRequest.getMissions(UserInfoModelController.sharedInstance().token, start: nil, limit: nil, status: nil, responser: self)
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
    
    func didReceiveNewOrder() {
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: NSString = NSString(string: "MyCommentsCell")
        
        var cell: MyCommentsTableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(identifier) as? MyCommentsTableViewCell
        
        var cellData = dataSource.objectAtIndex(indexPath.row) as TeacherComments

        cell!.usernameLabel!.text = cellData.studentNickname//cellData.studentName
        cell!.courseLabel!.text = cellData.courseTitle
        var range = cellData.createTime.rangeOfString("T") //
        var aRange: Range = Range(start: cellData.createTime.startIndex, end: range!.startIndex)
        cell!.timeLabel!.text = cellData.createTime.substringWithRange(aRange)
        cell!.mid = cellData.mid
        cell!.duration = cellData.duration
        cell!.username = cellData.studentName
        
        if cellData.numOfTopics < 0 {
            cell!.detailsLabel!.text = "Monthly Course"
            cell!.statusLabel!.text = "Monthly"
            cell!.statusLabel!.backgroundColor = UIColor.redColor()
        } /*else if cellData.numOfTopics == 0 {
            cell!.detailsLabel.text = "Finished Course"
            cell!.statusLabel.text = "Finished"
            cell!.statusLabel.backgroundColor = UserSettings.sharedInstance().grayTextColor
        }*/ else {
            cell!.detailsLabel!.text = "Remain Lessons: \(cellData.numOfTopics)"
            cell!.statusLabel!.text = "Handling"
            cell!.statusLabel!.backgroundColor = UserSettings.sharedInstance().themeColor
        }
        
        if cell!.avatarImageButton!.imageURL == nil || !cell!.avatarImageButton!.imageURL.isEqual(NSURL(string: "\(APIInfo.SERVER)\(cellData.studentAvatar)"))  {
            cell!.avatarImageButton!.placeholderImage = self.placeholderImage
            cell!.avatarImageButton!.imageURL = NSURL(string: "\(APIInfo.SERVER)\(cellData.studentAvatar)")
            cell!.avatarImageButton!.layer.masksToBounds = true
            cell!.avatarImageButton!.layer.cornerRadius = cell!.avatarImageButton!.frame.width / 2
            //println(cell!.avatarImageButton.imageURL.absoluteString)
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
    
    func didReceiveError() {
        
    }
    
    func didReceiveError(error: NetworkRequestErrorType, action: NSString) {
        if action.isEqualToString(APIInfo.GetTakeMissions) {
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
        if action.isEqualToString(APIInfo.GetTakeMissions) {
            println("==========================================")
            //print(data)
            println("==========================================")
            let result = data[JSONName.result] as NSMutableArray
            if result.count > 0 {
                //println(result)
                for obj in result {
                    var del = obj[JSONName.del] as Int
                    if del == 0 {
                        var studentAvatar = obj[JSONName.avatar] as String
                        var studentName = obj[JSONName.username] as String
                        var studentNickname = obj[JSONName.nickname] as? String
                        if studentNickname == nil {
                            studentNickname = ""
                        }
                        //println(obj[JSONName.nickname])
                        var createTime = obj[JSONName.createTime] as String
                        var courseTitle = obj[JSONName.title] as String
                        var comment = obj[JSONName.comment] as String
                        var mid = obj[JSONName.id] as Int
                        var score = obj[JSONName.score] as Int
                        var duration = obj[JSONName.duration] as Int
                        var numoftopic = obj[JSONName.numoftopic] as Int
                        var ifEvaluateStudent = obj[JSONName.ifEvaluateStudent] as Int
                        
                        var courseItem = TeacherComments(studentAvatar: studentAvatar, studentName: studentName, studentNickname: studentNickname!, createTime: createTime, courseTitle: courseTitle, comment: comment, mid: mid, duration:duration, score: score, numOfTopics: numoftopic, ifEvaluateStudent: ifEvaluateStudent)
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
        } else if action.isEqualToString(APIInfo.GetMissions) {
            println("==========================================")
            print(data)
            println("==========================================")
        }
    }
}
