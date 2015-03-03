//
//  ChatViewControllerManager.swift
//  yoteacher
//
//  Created by Park006 on 14-8-3.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class ChatViewControllerManager: NSObject {
    
    var currentChat: NSMutableDictionary = NSMutableDictionary()
    
    func addChatViewController(chatViewController: ChatViewController, chatter: String) {
        var obj: AnyObject! = currentChat.objectForKey(chatter)
        if (obj != nil) {
            return
        } else {
            currentChat.setObject(chatViewController, forKey: chatter)
        }
    }
    
    func getChatViewController(chatter: String) -> ChatViewController! {
        var chat: AnyObject! = currentChat.objectForKey(chatter)
        if (chat != nil) {
            return chat as ChatViewController
        } else {
            var newChat = ChatViewController(chatter: chatter)
            currentChat.setObject(newChat, forKey: chatter)
            return newChat
            //return nil
        }
    }
    
    func removeAll() {
        for (key, chat) in currentChat {
            (chat as ChatViewController).removeTimer()
        }
        currentChat.removeAllObjects()
    }
    
    class func sharedInstance() -> ChatViewControllerManager {
        struct Singleton {
            static var predicate: dispatch_once_t = 0
            static var instance: ChatViewControllerManager? = nil
        }
        
        dispatch_once(&(Singleton.predicate), {
            Singleton.instance = ChatViewControllerManager()
            })
        
        return Singleton.instance!
    }
}
