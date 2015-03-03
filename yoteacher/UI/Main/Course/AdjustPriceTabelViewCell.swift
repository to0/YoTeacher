//
//  AdjustPriceTabelViewCell.swift
//  yoteacher
//
//  Created by Park006 on 14-7-28.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class AdjustPriceTableViewCell: UITableViewCell, UIAlertViewDelegate, ResponseProtocol {
    
    @IBOutlet var addjustPriceButton: UIButton?
    var parentController: AdjustPriceViewController? = nil
    var id: Int = -1
    var charge: Double = -1
    var duration: Int = -1
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)  {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @IBAction func adjustPriceButtonTouchUpInside(sender: AnyObject) {
        var priceView = PriceView.instancePriceView()
        var alert = CXAlertView(title: "Adjust Price", contentView: priceView, cancelButtonTitle: "Cancel")
        alert.addButtonWithTitle("OK", type: CXAlertViewButtonType.Default, handler: { alertView, button -> Void in
            var priceTextField = priceView.viewWithTag(1) as UITextField
            if priceTextField.text.isEmpty || !self.isChargeText(priceTextField.text) {
                self.lockAnimationForView(priceTextField)
            } else {
                NetworkRequest.setTopic(UserInfoModelController.sharedInstance().token, id: self.id, charge: NSString(string: priceTextField.text).doubleValue, duration: self.duration, responser: self)
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
        if action.isEqualToString(APIInfo.SetTopic) {
            if data[JSONName.errno] as Int == 0 {
                if data[JSONName.result] as Int == 1 {
                    var alert = UIAlertView(title: "Notice", message: "Adjust price successfully", delegate: self, cancelButtonTitle: "OK")
                    //self.addjustPriceButton.setTitle(<#title: String?#>, forState: <#UIControlState#>)
                    if (self.parentController != nil) {
                        self.parentController!.reloadDataSource()
                    }
                    alert.delegate = self
                    NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "dismissAlertView:", userInfo: alert, repeats: false)
                    alert.show()
                } else {
                    var alert = UIAlertView(title: "Notice", message: "Failed to adjust price", delegate: self, cancelButtonTitle: "OK")
                    alert.delegate = self
                    NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "dismissAlertView:", userInfo: alert, repeats: false)
                    alert.show()
                }
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("click \(buttonIndex)")
        //alertView.dismissWithClickedButtonIndex(buttonIndex, animated: true)
    }
    
    func dismissAlertView(timer: NSTimer) {
        var alertView = timer.userInfo as? UIAlertView
        if alertView != nil {
            alertView!.dismissWithClickedButtonIndex(0, animated: true)
        }
    }
}
