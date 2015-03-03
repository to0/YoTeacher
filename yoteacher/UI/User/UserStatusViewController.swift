//
//  UserStatusViewController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-21.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreText

class UserStatusViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, QRadioButtonDelegate, ResponseProtocol {
    
    @IBOutlet var freeRadioButton: QRadioButton?
    @IBOutlet var busyRadioButton: QRadioButton?
    @IBOutlet var awayRadioButton: QRadioButton?
    @IBOutlet var statusRadioGroup: UIView?
    
    @IBOutlet var dynamicTextField: UITextField?
    @IBOutlet var avatarImageView: EGOImageView?
    
    @IBOutlet var changePasswordButton: UIButton?
    @IBOutlet var logoutButton: UIButton?
    
    var pwd: String = ""
    var selectedBgImg: UIImage = UIImage()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println(self.freeRadioButton.frame)
        //self.view.addSubview(freeRadioButton)
        
        var groupId1 = "groupId1"
        
        var statusFontSize = UserSettings.sharedInstance().statusFontSize
        self.freeRadioButton!.setTitle("Free", forState: UIControlState.Normal) // Explicit String!
        self.freeRadioButton!.setTitleColor(UserSettings.sharedInstance().grayTextColor, forState: UIControlState.Normal)
        self.freeRadioButton!.setTitleColor(UserSettings.sharedInstance().themeColor, forState: UIControlState.Selected)
        self.freeRadioButton!.titleLabel!.font = UIFont.boldSystemFontOfSize(CGFloat(statusFontSize))
        self.freeRadioButton!.selectedValue = 0
        self.freeRadioButton!.delegate = self
        self.freeRadioButton!.groupId = groupId1
        self.freeRadioButton!.addToGroup()
        self.freeRadioButton!.checked = true
        
        self.busyRadioButton!.setTitle("Busy", forState: UIControlState.Normal) // Explicit String!
        self.busyRadioButton!.setTitleColor(UserSettings.sharedInstance().grayTextColor, forState: UIControlState.Normal)
        self.busyRadioButton!.setTitleColor(UserSettings.sharedInstance().themeColor, forState: UIControlState.Selected)
        self.busyRadioButton!.titleLabel!.font = UIFont.boldSystemFontOfSize(CGFloat(statusFontSize))
        self.busyRadioButton!.selectedValue = 2
        self.busyRadioButton!.delegate = self
        self.busyRadioButton!.groupId = groupId1
        self.busyRadioButton!.addToGroup()
        
        self.awayRadioButton!.setTitle("Away", forState: UIControlState.Normal) // Explicit String!
        self.awayRadioButton!.setTitleColor(UserSettings.sharedInstance().grayTextColor, forState: UIControlState.Normal)
        self.awayRadioButton!.setTitleColor(UserSettings.sharedInstance().themeColor, forState: UIControlState.Selected)
        self.awayRadioButton!.titleLabel!.font = UIFont.boldSystemFontOfSize(CGFloat(statusFontSize))
        self.awayRadioButton!.selectedValue = 1
        self.awayRadioButton!.delegate = self
        self.awayRadioButton!.groupId = groupId1
        self.awayRadioButton!.addToGroup()
        
        self.avatarImageView!.placeholderImage = UIImage(named: "sliding_avatar")
        self.avatarImageView!.layer.masksToBounds = true
        self.avatarImageView!.layer.cornerRadius = self.avatarImageView!.frame.size.width / 2
        
        self.dynamicTextField!.text = UserInfoModelController.sharedInstance().twitter
        self.dynamicTextField!.delegate = self
        
        self.selectedBgImg = createImageWithColor(UserSettings.sharedInstance().themeColor)
        self.changePasswordButton!.layer.borderWidth = 1
        self.changePasswordButton!.layer.borderColor = UserSettings.sharedInstance().grayTextColor.CGColor
        self.changePasswordButton!.setBackgroundImage(self.selectedBgImg, forState: UIControlState.Highlighted)
        self.logoutButton!.layer.borderWidth = 1
        self.logoutButton!.layer.borderColor = UserSettings.sharedInstance().grayTextColor.CGColor
        self.logoutButton!.setBackgroundImage(self.selectedBgImg, forState: UIControlState.Highlighted)
        
        //self.statusRadioGroup.textFont = UIFont.systemFontOfSize(14.0) // Font Size
        //self.statusRadioGroup.addObserver(self, forKeyPath: "selectValue", options: NSKeyValueObservingOptions.fromRaw(0)!, context: nil)
        //self.statusRadioGroup.selectValue = 0;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //println(UserInfoModelController.sharedInstance().avatarPath)
        self.avatarImageView!.imageURL = NSURL(string: "\(APIInfo.SERVER)\(UserInfoModelController.sharedInstance().avatarPath)")
    }
    
    @IBAction func twitterEditingDidEnd(sender: AnyObject) {
        //println("End editing")
        NetworkRequest.setTwitter(UserInfoModelController.sharedInstance().token, twitter: dynamicTextField!.text, responser: self)
    }
    
    @IBAction func changePasswordButtonTouchUpInside(sender: AnyObject) {
        var pwdView = PasswordPopupView.instancePasswordPopupView()
        var alert = CXAlertView(title: "Change Password", contentView: pwdView, cancelButtonTitle: "Cancel")
        alert.addButtonWithTitle("OK", type: CXAlertViewButtonType.Default, handler: {alertView, button -> Void in
            var oldPwdTextField = pwdView.viewWithTag(1) as UITextField
            var newPwdTextField = pwdView.viewWithTag(2) as UITextField
            var cfmPwdTextField = pwdView.viewWithTag(3) as UITextField
            
            if (oldPwdTextField.text != UserInfoModelController.sharedInstance().password) {
                self.lockAnimationForView(oldPwdTextField)
            } else if (newPwdTextField.text.isEmpty) {
                self.lockAnimationForView(newPwdTextField)
            } else if (newPwdTextField.text != cfmPwdTextField.text) {
                self.lockAnimationForView(cfmPwdTextField)
            } else {
                NetworkRequest.setPassword(UserInfoModelController.sharedInstance().token, oldPwd: oldPwdTextField.text, newPwd: newPwdTextField.text, responser: self)
                self.pwd = newPwdTextField.text
                alertView.dismiss()
            }
            })
        alert.show()
    }
    
    func didPresentAlertView(alertView: UIAlertView) {
        println("alert test!")
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("alert click \(buttonIndex)")
    }
    
    @IBAction func logoutButtonTouchUpInside(sender: AnyObject) {
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as String
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userID")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
        
        NetworkRequest.updateStatus(token, status: self.awayRadioButton!.selectedValue, responser: self)
        EaseMob.sharedInstance().chatManager.asyncLogoff()
        APService.setAlias("", callbackSelector: nil, object: nil)
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.rootViewController.hideMenuViewController()
        (appDelegate.mainViewController.viewControllers[0] as MainViewController).releaseDataSource()
        ChatViewControllerManager.sharedInstance().removeAll()
        appDelegate.enterViewController(appDelegate.mainViewController, toViewController: appDelegate.loginViewController)
    }
    
    func didSelectedRadioButton(radio: QRadioButton!, groupId: String!) {
        if groupId == "groupId1" {
            var token: String = NSUserDefaults.standardUserDefaults().objectForKey("token") as String
            println(radio.titleLabel!.text)
            println(radio.selectedValue)
            NetworkRequest.updateStatus(token, status: radio.selectedValue, responser: self)
        }
    }
    
    func didReceiveError() {
        
    }
    
    func didReceiveError(error: NetworkRequestErrorType, action: NSString) {
        
    }
    
    func didReceiveResponse() {
        
    }
    
    func didReceiveResponse(data: NSDictionary, action: NSString) {
        if action.isEqualToString(APIInfo.UPDATESTATUS) { //Login
            println(data)
            if data[JSONName.errno] as Int == 0 {
                if data[JSONName.result] as Int == 1 {
                    println("update status successfully")
                } else {
                    println("failed to update status")
                }
            } else {
                println("failed to get api \(APIInfo.UPDATESTATUS)")
            }
        } else if action.isEqualToString(APIInfo.SetPassword) {
            if data[JSONName.errno] as Int == 0 {
                if data[JSONName.result] as Int == 1 {
                    var alert = UIAlertView(title: "Notice", message: "Change password successfully", delegate: self, cancelButtonTitle: "OK")
                    UserInfoModelController.sharedInstance().password = pwd
                        alert.show()
                } else {
                    var alert = UIAlertView(title: "Notice", message: "Failed to change password", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            } else {
                println("failed to get api \(APIInfo.SetPassword)")
            }
        } else if action.isEqualToString(APIInfo.SetTwitter) {
            if data[JSONName.errno] as Int == 0 {
                if data[JSONName.result] as Int == 1 {
                    UserInfoModelController.sharedInstance().twitter = self.dynamicTextField!.text
                } else {
                    self.dynamicTextField!.text = UserInfoModelController.sharedInstance().twitter
                }
            } else {
                println("failed to get api \(APIInfo.SetTwitter)")
            }
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
    
    func createImageWithColor(color: UIColor) -> UIImage {
        var rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        var context: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        var theImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return theImage
    }
}
