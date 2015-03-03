//
//  MainNavigationController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-24.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController, ResponseProtocol {
    
    func didReceiveResponse() {
        
    }
    
    func didReceiveResponse(data: NSDictionary, action: NSString) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if action.isEqualToString(APIInfo.LOGIN) {
            println(data)
            if data[JSONName.errno] as Int == 0 {
                let result = data[JSONName.result] as NSDictionary
                if result.count > 0 {
                    let token = result[JSONName.token] as NSString
                    if  token == "wrong" {
                        println("username or password wrong")
                    } else {
                        //NSUserDefaults.standardUserDefaults().setObject(appDelegate.loginViewController.userIDTextField.text, forKey: "userID")
                        //NSUserDefaults.standardUserDefaults().setObject(appDelegate.loginViewController.passwordTextField.text, forKey: "password")
                        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                        println("login successfully")
                        
                        UserInfoModelController.sharedInstance().token = token
                        //UserInfoModelController.sharedInstance().username = NSUserDefaults.standardUserDefaults().objectForKey("userID") as String
                        UserInfoModelController.sharedInstance().password = NSUserDefaults.standardUserDefaults().objectForKey("password") as String
                        NetworkRequest.getMyInfo(token, responser: self)
                        
                        appDelegate.enterViewController(appDelegate.loginViewController, toViewController: appDelegate.mainViewController)
                        return
                    }
                }
            }
            appDelegate.enterViewController(appDelegate.mainViewController, toViewController: appDelegate.loginViewController)
        } else if action.isEqualToString(APIInfo.GETMYINFO) {
            println(data)
            if data[JSONName.errno] as Int == 0 {
                let result = data[JSONName.result] as NSDictionary
                if result.count > 0 {
                    UserInfoModelController.sharedInstance().username = result[JSONName.username] as String
                    UserInfoModelController.sharedInstance().avatarPath = result[JSONName.avatar] as String
                    UserInfoModelController.sharedInstance().phone = result[JSONName.phone] as String
                    UserInfoModelController.sharedInstance().uid = result[JSONName.uid] as Int
                    UserInfoModelController.sharedInstance().twitter = result[JSONName.twitter] as String
                    UserInfoModelController.sharedInstance().status = result[JSONName.iffree] as Int
                    
                    EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(UserInfoModelController.sharedInstance().username, password: "123456", completion: { loginInfo, error -> Void in
                        if (error != nil) {
                            println(error.description)
                            EaseMob.sharedInstance().chatManager.registerNewAccount(UserInfoModelController.sharedInstance().username, password: "123456", error: nil)
                        } else {
                            println(loginInfo.description)
                        }
                        (appDelegate.mainViewController.viewControllers[0] as MainViewController).didUnreadMessagesCountChanged()
                        }, onQueue: nil)
                    (appDelegate.mainViewController.viewControllers[0] as MainViewController).reloadDataSource()
                    APService.setTags(NSSet(array: [UserInfoModelController.sharedInstance().username]), alias: UserInfoModelController.sharedInstance().username, callbackSelector: "tagsAliasCallback:", target: appDelegate)
                }
            }
        }
    }
    
    func didReceiveError() {
        
    }
    
    func didReceiveError(error: NetworkRequestErrorType, action: NSString) {
        if action.isEqualToString(APIInfo.LOGIN) {
            switch (error) {
            case NetworkRequestErrorType.NetworkConnectionError:
                println("Network Connection Error")
            case NetworkRequestErrorType.JSONDataError:
                println("Json Data Error")
            }
            
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.enterViewController(appDelegate.mainViewController, toViewController: appDelegate.loginViewController)
        } else if action.isEqualToString(APIInfo.GETMYINFO) {
            
        }
    }
    /*
    func didLoginWithInfo(loginInfo: [NSObject : AnyObject]!, error: EMError!) {
        println("login huanxin")
    }*/
}
