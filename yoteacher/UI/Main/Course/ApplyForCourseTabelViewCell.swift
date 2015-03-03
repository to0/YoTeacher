//
//  ApplyForCourseTabelViewCell.swift
//  yoteacher
//
//  Created by Park006 on 14-7-28.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class ApplyForCourseTabelViewCell: UITableViewCell, ResponseProtocol {
    
    @IBOutlet var applyForCourseButton: UIButton?
    //var parentController: ApplyForCourseViewController? = nil
    var title: String = ""
    var content: String = ""
    var id: Int = 0
    var duration: Int = 0
    var lang: Int = 0
    var classification: Int = 0
    var charge: Double = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @IBAction func applyForCourseButtonTouchUpInside(sender: AnyObject) {
        var applyView = ApplyView.instancePriceView()
        var alert = CXAlertView(title: "Apply for Course", contentView: applyView, cancelButtonTitle: "Cancel")
        /*var titleLabel = applyView.viewWithTag(3) as UILabel
        var contentLabel = applyView.viewWithTag(4) as UILabel
        titleLabel.text = self.title
        contentLabel.text = self.content*/
        applyView.titleTextField!.text = self.title
        applyView.contentTextField!.text = self.content
        if id > 0 {
            applyView.titleTextField!.enabled = false
            applyView.contentTextField!.enabled = false
        } else {
            applyView.titleTextField!.enabled = true
            applyView.contentTextField!.enabled = true
        }
        
        alert.addButtonWithTitle("OK", type: CXAlertViewButtonType.Default, handler: { alertView, button -> Void in
            var priceTextField = applyView.viewWithTag(1) as UITextField
            var durationTextField = applyView.viewWithTag(2) as UITextField
            if priceTextField.text.isEmpty || !self.isChargeText(priceTextField.text) {
                self.lockAnimationForView(priceTextField)
            } else if durationTextField.text.isEmpty || !self.isDurationText(durationTextField.text) {
                self.lockAnimationForView(durationTextField)
            } else {
                NetworkRequest.addTopic(UserInfoModelController.sharedInstance().token, tid: UserInfoModelController.sharedInstance().uid, ttid: self.id, charge: NSString(string: priceTextField.text).doubleValue, duration: self.duration, responser: self)
                alertView.dismiss()
            }
            })
        alert.show()
    }
    
    
    func isChargeText(str: String) -> Bool {
        var regex: NSString = "^[0-9]+\\.{0,1}[0-9]{0,2}$"
        var pred: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)!
        return pred.evaluateWithObject(str)
    }
    
    func isDurationText(str: String) -> Bool {
        var regex: NSString = "^\\+?[1-9][0-9]*$"
        var pred: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)!
        return pred.evaluateWithObject(str)
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
    
    func didReceiveError() {
        
    }
    
    func didReceiveError(error: NetworkRequestErrorType, action: NSString) {
        
    }
    
    func didReceiveResponse() {
        
    }
    
    func didReceiveResponse(data: NSDictionary, action: NSString) {
        if action.isEqualToString(APIInfo.AddTopic) {
            if data[JSONName.errno] as Int == 0 {
                if data[JSONName.result] as Int == 1 {
                    var alert = UIAlertView(title: "Notice", message: "Apply for course successfully", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                } else {
                    var alert = UIAlertView(title: "Notice", message: "Failed to apply for course", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
        }
    }
}
