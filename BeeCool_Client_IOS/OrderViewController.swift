//
//  SecondViewController.swift
//  BeeCool
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var alertLabel: UILabel!
    @IBOutlet var logbtn: UIButton!
    var userdefault = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if (userdefault.objectForKey("userLog") as NSString) == "" {
            logbtn.hidden = false
            logbtn.enabled = true
            alertLabel.hidden = false
            tableView.hidden = true
            tableView.allowsSelection = false
        }else {
            logbtn.hidden = true
            logbtn.enabled = false
            alertLabel.hidden = true
            tableView.hidden = false
            tableView.allowsSelection = true
        }
        logbtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        logbtn.layer.masksToBounds = true
        logbtn.layer.cornerRadius = 6
        self.tabBarController?.tabBar.hidden = false
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if userdefault.objectForKey("cellCount") == nil {
            return 0
        }
        var count = userdefault.objectForKey("cellCount") as Int
        return count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        view.backgroundColor = tableView.backgroundColor
        if userdefault.objectForKey("cellCount") == nil {
            return 0
        }
       return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("orderCell") as UITableViewCell
        var namelabel = cell.contentView.viewWithTag(101) as UILabel
        var timelabel = cell.contentView.viewWithTag(102) as UILabel
        var resultlabel = cell.contentView.viewWithTag(103) as UILabel
        namelabel.text = "车名：科尼赛克one"
        timelabel.text = "日期：2014－12－24－8:00"
        resultlabel.text = "等待确认"
        resultlabel.textColor = UIColor.redColor()
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 20
       
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
//        userdefault.removeObjectForKey("cellCount")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

