//
//  MyAccountViewController.swift
//  BeeCool
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var headImageView: UIImageView!
    @IBOutlet var headLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        headImageView.layer.borderWidth = 1;
        headImageView.layer.masksToBounds = true
        headImageView.layer.borderColor = UIColor.whiteColor().CGColor
        headImageView.layer.cornerRadius = headImageView.frame.width / 2
        // Do any additional setup after loading the view.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            return 0
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel.text = "服务地址"
            }
            if indexPath.row == 1 {
                cell.textLabel.text = "我的优惠券"
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel.text = "告诉朋友"
            }
            if indexPath.row == 1 {
                cell.textLabel.text = "给好评"
            }
            if indexPath.row == 2 {
                cell.textLabel.text = "更多设置"
            }
        }
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
