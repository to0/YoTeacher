//
//  ChangePasswordView.swift
//  yoteacher
//
//  Created by Park006 on 14-7-29.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordView: UIAlertView {
    
    var oldPasswordTextField: UITextField? = nil
    var newPasswordTextField: UITextField? = nil
    var confirmPasswordTextField: UITextField? = nil
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        createCustomField()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        createCustomField()
    }
    
    init(title: String!, message: String!, delegate: AnyObject!, cancelButtonTitle: String!) {
        super.init(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle)
        createCustomField()
    }
    
    func createCustomField() {
        self.oldPasswordTextField = self.createTextField("Old Password", frame:CGRectMake(22, 45, 240, 36))
        self.addSubview(self.oldPasswordTextField)
        
        self.newPasswordTextField = self.createTextField("New Password", frame:CGRectMake(22, 90, 240, 36))
        self.addSubview(self.newPasswordTextField)
        
        self.confirmPasswordTextField = self.createTextField("Confirm Password", frame:CGRectMake(22, 135, 240, 36))
        self.addSubview(self.confirmPasswordTextField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in self.subviews {
            if view.isKindOfClass(NSClassFromString("UIButton")) || view.isKindOfClass(NSClassFromString("UIThreePartButton")) {
                var vview = view as UIView
                var btnBounds: CGRect = vview.frame
                btnBounds.origin.y = self.confirmPasswordTextField!.frame.origin.y + self.confirmPasswordTextField!.frame.size.height + 7
                vview.frame = btnBounds
            }
        }
        
        var bounds: CGRect = self.frame;
        bounds.size.height = 260;
        self.frame = bounds;
    }
    
    func createTextField(placeholder: NSString, frame: CGRect) -> UITextField {
        var textField = UITextField(frame: frame)
        textField.placeholder = placeholder
        textField.secureTextEntry = true
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        return textField
    }
}
