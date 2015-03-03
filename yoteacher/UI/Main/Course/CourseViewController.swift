//
//  CourseViewController.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-19.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class CourseContent: NSObject, NSCopying {
    var title: String
    var content: String
    var id: Int
    var duration: Int
    var lang: Int
    var classification: Int
    var numOfTopics: Int
    var charge: Double
    
    override init() {
        self.title = ""
        self.content = ""
        self.id = 0
        self.charge = 0
        self.duration = 0
        self.lang = 0
        self.numOfTopics = 0
        self.classification = 0
    }
    
    init(id: Int, title: String, content: String, duration: Int, lang: Int, charge: Double, numOfTopics: Int, classification: Int) {
        self.id = id
        self.title = title
        self.content = content
        self.duration = duration
        self.lang = lang
        self.charge = charge
        self.numOfTopics = numOfTopics
        self.classification = classification
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return CourseContent(id: self.id, title: self.title, content: self.content, duration: self.duration, lang: self.lang, charge: self.charge, numOfTopics: self.numOfTopics, classification: self.classification)
    }
}

class CourseViewController: UIViewController {
    
    @IBOutlet var courseContainerView: UIView?
    @IBOutlet var courseSegmentedControl: UISegmentedControl?
    
    let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
    var adjustPriceViewController: AdjustPriceViewController
    var applyForCourseViewController: ApplyForCourseViewController
    var courseContainerViewController: UIViewController
    
    required init(coder aDecoder: NSCoder) {
        self.adjustPriceViewController = mainStroyboard.instantiateViewControllerWithIdentifier("AdjustPriceViewController") as AdjustPriceViewController
        self.applyForCourseViewController = mainStroyboard.instantiateViewControllerWithIdentifier("ApplyForCourseViewController") as ApplyForCourseViewController
        self.courseContainerViewController = UIViewController()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.courseContainerViewController.addChildViewController(self.adjustPriceViewController)
        self.adjustPriceViewController.view.frame = self.courseContainerViewController.view.frame
        self.applyForCourseViewController.view.frame = self.courseContainerViewController.view.frame
        self.courseContainerViewController.view.addSubview(self.adjustPriceViewController.view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier == "CourseContainerView" {
            self.courseContainerViewController = segue.destinationViewController as UIViewController
        }
    }
    
    func reloadDataSource() {
        self.adjustPriceViewController.reloadDataSource()
        self.applyForCourseViewController.reloadDataSource()
    }

    func releaseDataSource() {
        self.adjustPriceViewController.releaseDataSource()
        self.applyForCourseViewController.releaseDataSource()
    }
    
    @IBAction func courseSegmentedControlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //self.applyForCourseViewController.removeFromParentViewController()
            //self.courseContainerView.addSubview(self.adjustPriceViewController.view)
            println("change 0")
            
            self.courseContainerViewController.addChildViewController(self.adjustPriceViewController)
            self.applyForCourseViewController.willMoveToParentViewController(nil)
            self.adjustPriceViewController.view.frame = self.courseContainerViewController.view.frame
            self.courseContainerViewController.view.addSubview(self.adjustPriceViewController.view)
            self.courseContainerViewController.transitionFromViewController(self.applyForCourseViewController, toViewController: self.adjustPriceViewController, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {}, completion: {(finished: Bool) -> Void in
                self.applyForCourseViewController.view.removeFromSuperview()
                self.applyForCourseViewController.removeFromParentViewController()
                self.adjustPriceViewController.didMoveToParentViewController(self)})
            
        } else if sender.selectedSegmentIndex == 1 {
            //self.adjustPriceViewController.removeFromParentViewController()
            //self.courseContainerView.addSubview(self.applyForCourseViewController.view)
            println("change 1")
            
            self.courseContainerViewController.addChildViewController(self.applyForCourseViewController)
            self.adjustPriceViewController.willMoveToParentViewController(nil)
            self.applyForCourseViewController.view.frame = self.courseContainerViewController.view.frame
            self.courseContainerViewController.view.addSubview(self.applyForCourseViewController.view)
            self.courseContainerViewController.transitionFromViewController(self.adjustPriceViewController, toViewController: self.applyForCourseViewController, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {}, completion: {(finished: Bool) -> Void in
                self.adjustPriceViewController.view.removeFromSuperview()
                self.adjustPriceViewController.removeFromParentViewController()
                self.applyForCourseViewController.didMoveToParentViewController(self)})
        }
    }
}
