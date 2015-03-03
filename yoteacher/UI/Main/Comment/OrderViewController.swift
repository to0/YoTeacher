//
//  OrderViewController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-16.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import UIKit

class TeacherComments: NSObject, NSCopying {
    var studentAvatar: String
    var studentName: String
    var studentNickname: String
    var createTime: String
    var courseTitle: String
    var comment: String
    var mid: Int
    var duration: Int
    var score: Int
    var numOfTopics: Int
    var ifEvaluateStudent: Int
    
    override init() {
        self.studentAvatar = ""
        self.studentName = ""
        self.studentNickname = ""
        self.createTime = ""
        self.courseTitle = ""
        self.comment = ""
        self.mid = -1
        self.duration = -1
        self.score = 0
        self.numOfTopics = 0
        self.ifEvaluateStudent = 0
    }
    
    init(studentAvatar: String, studentName: String, studentNickname: String, createTime: String, courseTitle: String, comment: String, mid: Int, duration: Int, score: Int, numOfTopics: Int, ifEvaluateStudent: Int) {
        self.studentAvatar = studentAvatar
        self.studentName = studentName
        self.studentNickname = studentNickname
        self.createTime = createTime
        self.courseTitle = courseTitle
        self.comment = comment
        self.mid = mid
        self.duration = duration
        self.score = score
        self.numOfTopics = numOfTopics
        self.ifEvaluateStudent = ifEvaluateStudent
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return TeacherComments(studentAvatar: self.studentAvatar, studentName: self.studentName, studentNickname: self.studentNickname, createTime: self.createTime, courseTitle: self.courseTitle, comment: self.comment, mid: self.mid, duration: self.duration, score: self.score, numOfTopics: self.numOfTopics, ifEvaluateStudent: self.ifEvaluateStudent)
    }
}

class StudentComments: NSObject, NSCopying {
    var avatar: String
    var content: String
    var createTime: String
    var username: String
    var mid: String
    var score: Float
    
    override init() {
        self.avatar = ""
        self.content = ""
        self.createTime = ""
        self.username = ""
        self.mid = ""
        self.score = 0
    }
    
    init(avatar: String, username: String, content: String, createTime: String, score: Float) {
        self.avatar = avatar
        self.content = content
        self.createTime = createTime
        self.username = username
        self.mid = ""
        self.score = score
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return StudentComments(avatar: self.avatar, username: self.username, content: self.content, createTime: self.createTime, score: self.score)
    }
    
    /*
    override func copy() -> AnyObject! {
        return StudentComments(avatar: self.avatar, username: self.username, content: self.content, createTime: self.createTime, score: self.score)
    }*/
}

class OrderViewController: UIViewController {
    
    @IBOutlet var commentSegmentedControl: UISegmentedControl?
    @IBOutlet var commentContainerView: UIView?
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var myCommentViewController: MyCommentViewController
    var receivedCommentViewController: ReceivedCommentViewController
    var commentContainerViewController: UIViewController
    
    required init(coder aDecoder: NSCoder) {
        self.myCommentViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MyCommentViewController") as MyCommentViewController
        self.receivedCommentViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ReceivedCommentViewController") as ReceivedCommentViewController
        self.commentContainerViewController = UIViewController()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.commentContainerViewController.addChildViewController(self.myCommentViewController)
        self.myCommentViewController.view.frame = self.commentContainerViewController.view.frame
        self.receivedCommentViewController.view.frame = self.commentContainerViewController.view.frame
        self.commentContainerViewController.view.addSubview(self.myCommentViewController.view)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier == "CommentContainerView" {
            self.commentContainerViewController = segue.destinationViewController as UIViewController
        }
    }
    
    func reloadDataSource() {
        self.myCommentViewController.reloadDataSource()
        self.receivedCommentViewController.reloadDataSource()
    }
    
    func releaseDataSource() {
        self.myCommentViewController.releaseDataSource()
        self.receivedCommentViewController.releaseDataSource()
    }
    
    @IBAction func commentSegmentedControlValueChanged(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0 {
            self.commentContainerViewController.addChildViewController(self.myCommentViewController)
            self.receivedCommentViewController.willMoveToParentViewController(nil)
            self.myCommentViewController.view.frame = self.commentContainerViewController.view.frame
            self.commentContainerViewController.view.addSubview(self.myCommentViewController.view)
            self.commentContainerViewController.transitionFromViewController(self.receivedCommentViewController, toViewController: self.myCommentViewController, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {}, completion: {(finished: Bool) -> Void in
                self.receivedCommentViewController.view.removeFromSuperview()
                self.receivedCommentViewController.removeFromParentViewController()
                self.myCommentViewController.didMoveToParentViewController(self)
                })
        } else if sender.selectedSegmentIndex == 1 {
            self.commentContainerViewController.addChildViewController(self.receivedCommentViewController)
            self.myCommentViewController.willMoveToParentViewController(nil)
            self.receivedCommentViewController.view.frame = self.commentContainerViewController.view.frame
            self.commentContainerViewController.view.addSubview(self.receivedCommentViewController.view)
            self.commentContainerViewController.transitionFromViewController(self.myCommentViewController, toViewController: self.receivedCommentViewController, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {}, completion: {(finished: Bool) -> Void in
                self.myCommentViewController.view.removeFromSuperview()
                self.myCommentViewController.removeFromParentViewController()
                self.receivedCommentViewController.didMoveToParentViewController(self)})
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

