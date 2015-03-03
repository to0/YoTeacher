//
//  PasswordPopupView.swift
//  yoteacher
//
//  Created by Park006 on 14-7-29.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class PasswordPopupView: UIView, UITextFieldDelegate {

    @IBOutlet var oldPasswordTextField: UITextField?
    @IBOutlet var newPasswordTextField: UITextField?
    @IBOutlet var confirmPasswordTextField: UITextField?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func instancePasswordPopupView() -> PasswordPopupView {
        var nibArr: NSArray = NSBundle.mainBundle().loadNibNamed("PasswordPopupView", owner: nil, options: nil)
        var pwdView = nibArr.objectAtIndex(0) as PasswordPopupView
        pwdView.frame = CGRect(x: pwdView.frame.origin.x, y: pwdView.frame.origin.y, width: 200, height: 140)
        pwdView.oldPasswordTextField!.delegate = pwdView
        pwdView.newPasswordTextField!.delegate = pwdView
        pwdView.confirmPasswordTextField!.delegate = pwdView
        return pwdView
    }
    
    func hideKeyboards() {
        oldPasswordTextField!.resignFirstResponder()
        newPasswordTextField!.resignFirstResponder()
        confirmPasswordTextField!.resignFirstResponder()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        hideKeyboards()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
