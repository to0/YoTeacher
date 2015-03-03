//
//  AppDelegate.swift
//  yoteacher
//
//  Created by Park006 on 14-7-26.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
    let userStoryboard = UIStoryboard(name: "User", bundle: nil)
    var mainViewController: MainNavigationController
    var loginViewController: LoginViewController
    var rootViewController: RootViewController
    var userStatusViewController: UserStatusViewController
    var window: UIWindow?

    override init() {
        rootViewController = mainStoryboard.instantiateViewControllerWithIdentifier("RootViewController") as RootViewController
        mainViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainNavigationController") as MainNavigationController
        loginViewController = loginStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
        userStatusViewController = userStoryboard.instantiateInitialViewController() as UserStatusViewController
        rootViewController.contentViewController = mainViewController
        rootViewController.menuViewController = userStatusViewController
        super.init()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = rootViewController
        self.window!.addSubview(rootViewController.view)
        self.window!.makeKeyAndVisible()
        
        var notificationTypes: UIRemoteNotificationType  = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound | UIRemoteNotificationType.Alert
#if !TARGET_IPHONE_SIMULATOR
        UIApplication.sharedApplication().registerForRemoteNotificationTypes(notificationTypes)
#endif
        
        var defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: Selector("networkDidSetup:"), name: "\(kAPNetworkDidSetupNotification)", object: nil)
        defaultCenter.addObserver(self, selector: Selector("networkDidClose:"), name: "\(kAPNetworkDidCloseNotification)", object: nil)
        defaultCenter.addObserver(self, selector: Selector("networkDidRegister:"), name: "\(kAPNetworkDidRegisterNotification)", object: nil)
        defaultCenter.addObserver(self, selector: Selector("networkDidLogin:"), name: "\(kAPNetworkDidLoginNotification)", object: nil)
        defaultCenter.addObserver(self, selector: Selector("networkDidReceiveMessage:"), name: "\(kAPNetworkDidReceiveMessageNotification)", object: nil)

        // EaseMob
        EaseMob.sharedInstance().registerSDKWithAppKey("yozaiitech#yozaii", apnsCertName: "chat_dev")
        EaseMob.sharedInstance().enableBackgroundReceiveMessage()
        //EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        if launchOptions == nil {
            EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: NSDictionary(objects: [], forKeys: []))
        } else {
            EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        /*
        println("notificationType Badge: \(UIRemoteNotificationType.Badge.toRaw())")
        println("notificationType Sound: \(UIRemoteNotificationType.Sound.toRaw())")
        println("notificationType Alert: \(UIRemoteNotificationType.Alert.toRaw())")
        println("notificationType: \(Int32.from(notificationTypes.value.toIntMax()))")*/
        
        //JPush
        println("notificationType: \(Int32(notificationTypes.rawValue.toIntMax()))")
        APService.registerForRemoteNotificationTypes(Int32(notificationTypes.rawValue))
        APService.setupWithOption(launchOptions)
        
        //var tmp: Int32 = notificationTypes.value
        /*
        var error: EMError? = nil
        EaseMob.sharedInstance().chatManager.registerNewAccount("Emma", password: "Emma", error: &error)
        if error {
            println(error.description)
        }*/
        
        var userID : String? = NSUserDefaults.standardUserDefaults().stringForKey("userID")
        var password : String? = NSUserDefaults.standardUserDefaults().stringForKey("password")
        
        if userID != nil && password != nil {
            println("userID: " + userID!)
            println("password: " + password!)
            NetworkRequest.userLogin(userID!, password: password!, responser: self.mainViewController)
            //enterViewController(self.rootViewController.contentViewController, toViewController: self.mainViewController)
        } else {
            enterViewController(self.rootViewController.contentViewController, toViewController: self.loginViewController)
        }
        
        return true
    }
    
    func enterViewController(fromViewControlloer: UIViewController, toViewController: UIViewController) {
        self.rootViewController.contentViewController = toViewController
        fromViewControlloer.view.removeFromSuperview()
        self.rootViewController.view.addSubview(toViewController.view)
        //self.rootViewController.addChildViewController(viewControlloer)
        //self.rootViewController.view.addSubview(viewControlloer.view)
        //self.window!.makeKeyAndVisible()
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //println("----------------------------\(deviceToken)")
        EaseMob.sharedInstance().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        APService.registerDeviceToken(deviceToken)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        EaseMob.sharedInstance().applicationWillResignActive(application)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        EaseMob.sharedInstance().applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        EaseMob.sharedInstance().applicationWillEnterForeground(application)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        EaseMob.sharedInstance().applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        EaseMob.sharedInstance().applicationWillTerminate(application)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        APService.handleRemoteNotification(userInfo)
        /*
        application.applicationIconBadgeNumber = 0;
        
        var apns: NSDictionary = userInfo["aps"] as NSDictionary
        var content: NSString = apns["alert"] as NSString
        var badge: NSInteger? = apns["badge"]?.integerValue
        var sound: NSString = apns["sound"] as NSString*/
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        println("Receive Remote Notification: date: \(dateFormatter.stringFromDate(NSDate())) userInfo: \(userInfo)")
        
        application.applicationIconBadgeNumber = 0;
        
        var apns: NSDictionary? = userInfo["aps"] as? NSDictionary
        if apns != nil {
            var content: String = apns!["alert"] as String
            var badge: NSInteger? = apns!["badge"]?.integerValue
            var sound: String = apns!["sound"] as String
            
            var mainViewController = self.mainViewController.viewControllers[0] as MainViewController
            var orderViewController = mainViewController.viewControllers![1] as OrderViewController
            if (content.rangeOfString("课程", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil) != nil) {
                var myCommentsTabelViewController = orderViewController.myCommentViewController
                mainViewController.selectedIndex = 1
                if orderViewController.commentSegmentedControl!.selectedSegmentIndex != 0 {
                    orderViewController.commentSegmentedControl!.selectedSegmentIndex = 0
                    orderViewController.commentSegmentedControlValueChanged(orderViewController.commentSegmentedControl!)
                }
                myCommentsTabelViewController.reloadDataSource()
            } else {
                var receivedCommentsTabelViewController = orderViewController.receivedCommentViewController
                mainViewController.selectedIndex = 1
                if orderViewController.commentSegmentedControl!.selectedSegmentIndex != 1 {
                    orderViewController.commentSegmentedControl!.selectedSegmentIndex = 1
                    orderViewController.commentSegmentedControlValueChanged(orderViewController.commentSegmentedControl!)
                }
                receivedCommentsTabelViewController.reloadDataSource()
            }
        }
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)) {
        println("backgroud:")
        println(userInfo)
        APService.handleRemoteNotification(userInfo)
        
        var apns: NSDictionary? = userInfo["aps"] as? NSDictionary
        if apns != nil {
            var content: String = apns!["alert"] as String
            var badge: NSInteger? = apns!["badge"]?.integerValue
            var sound: String = apns!["sound"] as String
            
            var mainViewController = self.mainViewController.viewControllers[0] as MainViewController
            var orderViewController = mainViewController.viewControllers![1] as OrderViewController
            if (content.rangeOfString("课程", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil) != nil) {
                var myCommentsTabelViewController = orderViewController.myCommentViewController
                mainViewController.selectedIndex = 1
                if orderViewController.commentSegmentedControl!.selectedSegmentIndex != 0 {
                    orderViewController.commentSegmentedControl!.selectedSegmentIndex = 0
                    orderViewController.commentSegmentedControlValueChanged(orderViewController.commentSegmentedControl!)
                }
                myCommentsTabelViewController.reloadDataSource()
            } else {
                var receivedCommentsTabelViewController = orderViewController.receivedCommentViewController
                mainViewController.selectedIndex = 1
                if orderViewController.commentSegmentedControl!.selectedSegmentIndex != 1 {
                    orderViewController.commentSegmentedControl!.selectedSegmentIndex = 1
                    orderViewController.commentSegmentedControlValueChanged(orderViewController.commentSegmentedControl!)
                }
                receivedCommentsTabelViewController.reloadDataSource()
            }
        }
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func networkDidSetup(notification: NSNotification){
        println("---Connected---")
    }
    
    func networkDidClose(notification: NSNotification) {
        println("---Not Connected---")
    }
    
    func networkDidRegister(notification: NSNotification) {
        println("---Registered---")
    }
    
    func networkDidLogin(notification: NSNotification) {
        println("---Logged In---")
    }
    
    func networkDidReceiveMessage(notification: NSNotification) {
        var userInfo: NSDictionary? = notification.userInfo
        //var content: NSString = userInfo.valueForKey("alert") as NSString
        //var badge: Int = userInfo.valueForKey("badge") as Int
        //var sound: NSString = userInfo.valueForKey("sound") as NSString
        
        if userInfo == nil {
            return
        }
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        println("Receive Message: date: \(dateFormatter.stringFromDate(NSDate())) userInfo: \(userInfo)")
        //println("收到消息\ndate:%@\ntitle:%@\ncontent:%@", dateFormatter.stringFromDate(NSDate()), title, content)
        var content: String? = userInfo!["content"] as? String
        if content != nil {
            var mainViewController = self.mainViewController.viewControllers[0] as MainViewController
            var orderViewController = mainViewController.viewControllers![1] as OrderViewController
            var myCommentsTabelViewController = orderViewController.myCommentViewController
            mainViewController.selectedIndex = 1
            if orderViewController.commentSegmentedControl!.selectedSegmentIndex != 0 {
                orderViewController.commentSegmentedControl!.selectedSegmentIndex = 0
                orderViewController.commentSegmentedControlValueChanged(orderViewController.commentSegmentedControl!)
            }
            myCommentsTabelViewController.reloadDataSource()
            var alertView = UIAlertView(title: "Notice", message: "Receive a new mission!", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    
    func tagsAliasCallback(sender: AnyObject?) {
        println("Set tags alias\n")
    }
}

