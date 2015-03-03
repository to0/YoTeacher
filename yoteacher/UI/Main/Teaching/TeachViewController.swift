//
//  TeachViewController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-16.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import UIKit

class TeachViewController: ChatListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.view.tintColor = UserSettings.sharedInstance().blackTextColor
        self.urlHost = APIInfo.SERVER
        self.apiHost = APIInfo.HOST
        self.parentViewController!.navigationItem.title = "Teaching"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var conversation: EMConversation! = self.dataSource.objectAtIndex(indexPath.row) as EMConversation
        var cell: ChatListCell = self.tableView.cellForRowAtIndexPath(indexPath) as ChatListCell
        
        if conversation == nil {
            println("no such user")
            return
        }
        
        var chatController: ChatViewController
        var title:NSString = conversation.chatter;
        chatController = ChatViewControllerManager.sharedInstance().getChatViewController(conversation.chatter)//ChatViewController(chatter: conversation.chatter)
        println("here")
        
        chatController.title = cell.name;
        chatController.chatterAvatarURL = cell.imageURL
        chatController.myAvatarURL = NSURL(string: (APIInfo.SERVER + UserInfoModelController.sharedInstance().avatarPath))
        chatController.placeholderImage = cell.placeholderImage
        conversation.markMessagesAsRead(true)

        self.navigationController!.pushViewController(chatController, animated: true)
    }
}

