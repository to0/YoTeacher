//
//  PriceView.swift
//  yoteacher
//
//  Created by Park006 on 14-7-29.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class PriceView: UIView, UITextFieldDelegate {
    
    @IBOutlet var priceTextField: UITextField?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    class func instancePriceView() -> PriceView {
        var nibArr: NSArray = NSBundle.mainBundle().loadNibNamed("PriceView", owner: nil, options: nil)
        var prView = nibArr.objectAtIndex(0) as PriceView
        prView.frame = CGRect(x: prView.frame.origin.x, y: prView.frame.origin.y, width: 200, height: 50)
        prView.priceTextField!.delegate = prView
        return prView
    }
    
    func hideKeyboards() {
        priceTextField!.resignFirstResponder()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        hideKeyboards()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}