//
//  UserInfoModelController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-21.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class UserInfoModelController: NSObject {
    
    var token: String = ""
    var tid: Int = -1
    var uid: Int = -1
    var limit: Int = 10
    var username: String = ""
    var password: String = ""
    var nickname: String = ""
    var phone: String = ""
    var gender: String = ""
    var address: String = ""
    var avatarPath: String = ""
    var twitter: String = ""
    var status: Int = -1
    var userImage: UIImage = UIImage()
    
    class func sharedInstance() -> UserInfoModelController {
        struct Singleton {
            static var predicate: dispatch_once_t = 0
            static var instance: UserInfoModelController? = nil
        }
        
        dispatch_once(&(Singleton.predicate), {
            Singleton.instance = UserInfoModelController()
            })
        
        return Singleton.instance!
    }
}

class UserSettings: NSObject {
    var themeColor: UIColor = UIColor(red: 75.0/255.0, green: 193.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    var backgroudColor: UIColor = UIColor(white: 243.0/255/0, alpha: 1.0)
    var blackTextColor: UIColor = UIColor(white: 64.0/255.0, alpha: 1.0)
    var grayTextColor: UIColor = UIColor(white: 158.0/255.0, alpha: 1.0)
    var statusFontSize: Float = 11
    var titleFontSize: Float = 20
    
    class func sharedInstance() -> UserSettings {
        struct Singleton {
            static var predicate: dispatch_once_t = 0
            static var instance: UserSettings? = nil
        }
        
        dispatch_once(&(Singleton.predicate), {
            Singleton.instance = UserSettings()
            })
        
        return Singleton.instance!
    }
}