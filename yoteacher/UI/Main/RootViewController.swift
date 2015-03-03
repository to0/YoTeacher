//
//  RootViewController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-23.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: REFrostedViewController {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("root")
    }
    
    override init(contentViewController: UIViewController, menuViewController: UIViewController) {
        super.init(contentViewController: contentViewController, menuViewController: menuViewController)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}