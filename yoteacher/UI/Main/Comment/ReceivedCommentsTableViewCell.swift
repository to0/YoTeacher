//
//  ReceivedCommentsTableViewCell.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-18.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class ReceivedCommentsTableViewCell: UITableViewCell {
    
    @IBOutlet var avatarImageButton: EGOImageButton?
    @IBOutlet var commentLabel: UILabel?
    @IBOutlet var scoreLabel: UILabel?
    @IBOutlet var timeLabel: UILabel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @IBAction func avatarImageButtonTouchUpInside(sender: AnyObject) {
    }
}
