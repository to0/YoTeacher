//
//  ApplyView.swift
//  yoteacher
//
//  Created by Park006 on 14-7-29.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class ApplyView: UIView, UITextFieldDelegate {
    
    @IBOutlet var priceTextField: UITextField?
    @IBOutlet var durationTextField: UITextField?
    @IBOutlet var titleTextField: UITextField?
    @IBOutlet var contentTextField: UITextField?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    class func instancePriceView() -> ApplyView {
        var nibArr: NSArray = NSBundle.mainBundle().loadNibNamed("ApplyView", owner: nil, options: nil)
        var appView = nibArr.objectAtIndex(0) as ApplyView
        appView.frame = CGRect(x: appView.frame.origin.x, y: appView.frame.origin.y, width: 200, height: 150)
        appView.priceTextField!.delegate = appView
        appView.durationTextField!.delegate = appView
        appView.titleTextField!.delegate = appView
        appView.contentTextField!.delegate = appView
        return appView
    }
    
    func hideKeyboards() {
        priceTextField!.resignFirstResponder()
        durationTextField!.resignFirstResponder()
        titleTextField!.resignFirstResponder()
        contentTextField!.resignFirstResponder()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        hideKeyboards()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}