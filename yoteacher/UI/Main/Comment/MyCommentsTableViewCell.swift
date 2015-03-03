//
//  MyCommentsTableViewCell.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-18.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class MyCommentsTableViewCell: UITableViewCell, ResponseProtocol {
    
    @IBOutlet var avatarImageButton: EGOImageButton?
    @IBOutlet var usernameLabel: UILabel?
    @IBOutlet var courseLabel: UILabel?
    @IBOutlet var timeLabel: UILabel?
    @IBOutlet var commentButton: UIButton?
    @IBOutlet var statusLabel: UILabel?
    @IBOutlet var detailsLabel: UILabel?
    
    var mid: Int = -1
    var status: Int = -1
    var duration: Int = -1
    var username: String = ""
    //var lineView: UIView = UIView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)  {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /*
        lineView = UIView(frame: CGRectMake(0, 0, self.contentView.frame.size.width, 1))
        lineView.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 0.7)
        self.contentView.addSubview(self.lineView)*/
    }
    
    @IBAction func avatarButtonTouchUpInside(sender: AnyObject) {
        
        var conversation: EMConversation! = EaseMob.sharedInstance().chatManager.conversationForChatter(username, isGroup: false)
        
        if (conversation != nil) {
            println("no such user")
            return
        }
        
        var chatController: ChatViewController
        var title:NSString = conversation.chatter;
        chatController = ChatViewControllerManager.sharedInstance().getChatViewController(conversation.chatter)//ChatViewController(chatter: conversation.chatter)
        chatController.setTimer(Int32(duration.toIntMax()) * 60)
        
        chatController.title = usernameLabel!.text;
        chatController.myAvatarURL = NSURL(string: (APIInfo.SERVER + UserInfoModelController.sharedInstance().avatarPath))
        chatController.chatterAvatarURL = avatarImageButton!.imageURL
        conversation.markMessagesAsRead(true)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.mainViewController.pushViewController(chatController, animated: true)
        //[self.navigationController pushViewController:chatController animated:YES];
    }
    
    @IBAction func commentButtonTouchUpInside(sender: AnyObject) {
        //NetworkRequest.confirmMission(UserInfoModelController.sharedInstance().token, mid: mid, responser: self)
        var commentView = CommentView.instanceCommentView()
        var alert = CXAlertView(title: "Comment", contentView: commentView, cancelButtonTitle: "Cancel")
        alert.addButtonWithTitle("OK", type: CXAlertViewButtonType.Default, handler: { alertView, button -> Void in
            var commentTextView = commentView.viewWithTag(1) as UITextView
            var shortCommentTextField = commentView.viewWithTag(2) as UITextField
            if commentTextView.text.isEmpty && shortCommentTextField.text.isEmpty {
                self.lockAnimationForView(commentTextView)
            } else {
                if shortCommentTextField.text.isEmpty {
                    NetworkRequest.evaluateStudent(UserInfoModelController.sharedInstance().token, mid: self.mid, content: commentTextView.text, responser: self)
                } else {
                    NetworkRequest.setComment(UserInfoModelController.sharedInstance().token, mid: self.mid, content: commentTextView.text, shortContent: shortCommentTextField.text, responser: self)
                }
                //println(commentTextView.text)
                alertView.dismiss()
            }
            })
        alert.show()
    }
    
    func lockAnimationForView (view : UIView) {
        var lbl = view.layer
        var posLbl = lbl.position
        var y = CGPointMake(posLbl.x - 10, posLbl.y)
        var x = CGPointMake(posLbl.x + 10, posLbl.y)
        var animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = NSValue(CGPoint: x)
        animation.toValue = NSValue(CGPoint: y)
        animation.autoreverses = true
        animation.duration = 0.08
        animation.repeatCount = 3
        lbl.addAnimation(animation, forKey: nil)
    }
    
    func didReceiveError() {
        
    }
    
    func didReceiveError(error: NetworkRequestErrorType, action: NSString) {
        if action.isEqualToString(APIInfo.EvaluateStudent) || action.isEqualToString(APIInfo.SetComment) {
            var alert = UIAlertView(title: "Notice", message: "Failed to comment the student", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func didReceiveResponse() {
        
    }
    
    func didReceiveResponse(data: NSDictionary, action: NSString) {
        if action.isEqualToString(APIInfo.EvaluateStudent) || action.isEqualToString(APIInfo.SetComment) {
            println(data)
            if data[JSONName.errno] as Int == 0 {
                if data[JSONName.result] as Int == 1 {
                    var alert = UIAlertView(title: "Notice", message: "Comment the student successfully", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                } else {
                    var alert = UIAlertView(title: "Notice", message: "Failed to comment the student", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            } else {
                var alert = UIAlertView(title: "Notice", message: "Failed to comment the student", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }
}