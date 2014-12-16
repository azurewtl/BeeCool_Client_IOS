//
//  SecondViewController.swift
//  BeeCool
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet var logbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var userdefault = NSUserDefaults.standardUserDefaults()
        if (userdefault.objectForKey("userLog") as NSString) == "" {
            logbtn.hidden = false
            logbtn.enabled = true
        }else {
            logbtn.hidden = true
            logbtn.enabled = false
        }
        logbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        logbtn.layer.masksToBounds = true
        logbtn.layer.cornerRadius = 6
        self.tabBarController?.tabBar.hidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

