//
//  MainViewController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-16.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UITabBarController, IChatManagerDelegate {
    
    //var titleLabel: UILabel = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.didUnreadMessagesCountChanged()
        self.registerNotifications()
        /*
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        self.titleLabel.text = "Teaching"
        self.titleLabel.textAlignment = NSTextAlignment.Center
        self.titleLabel.font = UIFont.boldSystemFontOfSize(UserSettings.sharedInstance().titleFontSize)
        self.titleLabel.textColor = UIColor.whiteColor()*/
        /*
        self.navigationItem.titleView = self.titleLabel
        self.navigationController.navigationBar.barTintColor = UserSettings.sharedInstance().themeColor
        self.navigationController.navigationBar.tintColor = UIColor.whiteColor()*/
        self.tabBar.tintColor = UserSettings.sharedInstance().themeColor
        self.tabBar.barTintColor = UserSettings.sharedInstance().backgroudColor
        self.tabBar.backgroundColor
            = UserSettings.sharedInstance().backgroudColor
        
        self.setupUnreadMessageCount()
        
        //self.view.tintColor = UserSettings.sharedInstance().blackTextColor
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //self.titleLabel.text = item.title
        self.navigationItem.title = item.title
    }
    
    @IBAction func showSideMenu(sender: AnyObject) {
        self.frostedViewController.presentMenuViewController()
    }
    
    func reloadDataSource() {
        //(self.viewControllers[0] as TeachViewController).refreshDataSource()
        (self.viewControllers![1] as OrderViewController).reloadDataSource()
        (self.viewControllers![2] as CourseViewController).reloadDataSource()
        //self.setupUnreadMessageCount()
    }
    
    func releaseDataSource() {
        (self.viewControllers![0] as TeachViewController).releaseDataSource()
        (self.viewControllers![0] as TeachViewController).tabBarItem.badgeValue = nil
        (self.viewControllers![1] as OrderViewController).releaseDataSource()
        (self.viewControllers![2] as CourseViewController).releaseDataSource()
    }
    
    func registerNotifications() {
        self.unregisterNotifications()
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue:nil)
    }
    
    func unregisterNotifications() {
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
    }

    func setupUnreadMessageCount() {
        var conversations: NSArray = EaseMob.sharedInstance().chatManager.conversations
        var unreadCount: UInt = 0
        for conversation in conversations {
            unreadCount += (conversation as EMConversation).unreadMessagesCount()
        }
        
        if (self.viewControllers?.count > 0) {
            var teachingViewController = self.viewControllers![0] as TeachViewController
            if (unreadCount > 0) {
                println("unreadCount: \(unreadCount)")
                teachingViewController.tabBarItem.badgeValue = "\(unreadCount)";
            } else {
                println("unreadCount: \(0)")
                teachingViewController.tabBarItem.badgeValue = nil;
            }
        }
    }
    
    func didUnreadMessagesCountChanged() {
        self.setupUnreadMessageCount()
    }
}