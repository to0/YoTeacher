//
//  LoginViewController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-16.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class LoginViewController: UIViewController, UITextFieldDelegate, ResponseProtocol {

    @IBOutlet var userIDTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    @IBOutlet var logoImageView: UIImageView?
    
    let loginRequest: NetworkRequest = NetworkRequest()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDTextField!.delegate = self
        passwordTextField!.delegate = self
    }
    
    @IBAction func loginButtonTouchUpInside(sender: UIButton) {
        if userIDTextField!.text.isEmpty {
            println("userID empty")
            self.lockAnimationForView(userIDTextField!)
        } else if passwordTextField!.text.isEmpty {
            println("password empty")
            self.lockAnimationForView(passwordTextField!)
        } else {
            NetworkRequest.userLogin(userIDTextField!.text, password: passwordTextField!.text, responser: self)
        }
    }
    
    func didReceiveResponse() {
        
    }
    
    func didReceiveResponse(data: NSDictionary, action: NSString) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if action.isEqualToString(APIInfo.LOGIN) { //Login
            println(data)
            if data[JSONName.errno] as Int == 0 {
                let result = data[JSONName.result] as NSDictionary
                if result.count > 0 {
                    let token = result[JSONName.token] as NSString
                    if  token == "wrong" {
                        println("username or password wrong")
                        self.lockAnimationForView(passwordTextField!)
                    } else {
                        NSUserDefaults.standardUserDefaults().setObject(userIDTextField!.text, forKey: "userID")
                        NSUserDefaults.standardUserDefaults().setObject(passwordTextField!.text, forKey: "password")
                        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
                        println("login successfully")
                        
                        UserInfoModelController.sharedInstance().token = token
                        //UserInfoModelController.sharedInstance().username = userIDTextField.text
                        UserInfoModelController.sharedInstance().password = passwordTextField!.text
                        NetworkRequest.getMyInfo(token, responser: self)
                        
                        appDelegate.enterViewController(appDelegate.loginViewController, toViewController: appDelegate.mainViewController)
                    }
                }
            }
        } else if action.isEqualToString(APIInfo.GETMYINFO) { //GetMyInfo
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
                    
                    //EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(UserInfoModelController.sharedInstance().username, password: UserInfoModelController.sharedInstance().password)
                    
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
            switch error {
            case NetworkRequestErrorType.NetworkConnectionError:
                println("Network Connection Error")
            case NetworkRequestErrorType.JSONDataError:
                println("Json Data Serialization Error")
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var animationDuration: NSTimeInterval = 0.30
        
        UIView.beginAnimations("ResizeForKeyBoard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        
        var rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.frame = rect
        
        UIView.commitAnimations()
        
        self.userIDTextField?.resignFirstResponder()
        self.passwordTextField?.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        var frame = textField.frame
        var offset = frame.origin.y - (self.view.frame.size.height - 280.0)
        var animationDuration: NSTimeInterval = 0.30
        
        UIView.beginAnimations("ResizeForKeyBoard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        
        var width = self.view.frame.size.width
        var height = self.view.frame.size.height
        
        if offset > 0 {
            var rect = CGRect(x: 0, y: -offset, width: width, height: height)
            self.view.frame = rect
        }
        
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var animationDuration: NSTimeInterval = 0.30
        
        UIView.beginAnimations("ResizeForKeyBoard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        
        var rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.frame = rect
        
        UIView.commitAnimations()
        
        textField.resignFirstResponder()
        return true
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
}
