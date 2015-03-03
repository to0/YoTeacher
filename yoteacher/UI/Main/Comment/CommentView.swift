//
//  File.swift
//  yoteacher
//
//  Created by Park006 on 14-7-29.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class CommentView: UIView, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var commentTextView: UITextView?
    @IBOutlet var shortCommentTextField: UITextField?
    @IBOutlet var placeholderLabel: UILabel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    class func instanceCommentView() -> CommentView {
        var nibArr: NSArray = NSBundle.mainBundle().loadNibNamed("CommentView", owner: nil, options: nil)
        var cmtView = nibArr.objectAtIndex(0) as CommentView
        cmtView.frame = CGRect(x: cmtView.frame.origin.x, y: cmtView.frame.origin.y, width: 200, height: 100)
        cmtView.commentTextView!.delegate = cmtView
        cmtView.shortCommentTextField!.delegate = cmtView

        return cmtView
    }
    
    func hideKeyboards() {
        commentTextView!.resignFirstResponder()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        hideKeyboards()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            self.placeholderLabel!.text = "Student Comment"
        } else {
            self.placeholderLabel!.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}