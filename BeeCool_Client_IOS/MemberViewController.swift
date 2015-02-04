//
//  MemberViewController.swift
//  BeeCool
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cardArray = NSArray()
    var moneyArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        cardArray = ["金卡", "铂金卡", "钻石卡"] as NSArray
        moneyArray = ["充1000(反100)", "充3000(反500)", "充 6000(反 1000)"] as NSArray
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NVG1"), forBarMetrics: UIBarMetrics.Default)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.hidden = false
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "加入会员"
        }
        return ""
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("memberCell") as UITableViewCell
        var label = cell.contentView.viewWithTag(101) as UILabel
        var detaillabel = cell.contentView.viewWithTag(102) as UILabel
        var button = cell.contentView.viewWithTag(103) as UIButton
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.cyanColor().CGColor
        label.text = cardArray.objectAtIndex(indexPath.row) as NSString
        detaillabel.text = moneyArray.objectAtIndex(indexPath.row) as NSString
        return cell
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
