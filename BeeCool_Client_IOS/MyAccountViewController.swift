//
//  MyAccountViewController.swift
//  BeeCool
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet var headImageView: UIImageView!
    @IBOutlet var headLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var userdefault = NSUserDefaults.standardUserDefaults()
        if (userdefault.objectForKey("userLog") as NSString) == "" {
            headLabel.text = "立即登陆"
        }else {
            tapGesture.enabled = false
            headLabel.text = userdefault.objectForKey("userLog") as NSString
        }
        
        headImageView.layer.borderWidth = 1;
        headImageView.layer.masksToBounds = true
        headImageView.layer.borderColor = UIColor.whiteColor().CGColor
        headImageView.layer.cornerRadius = headImageView.frame.width / 2
        self.tabBarController?.tabBar.hidden = false
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 0
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
                cell.textLabel.text = "服务地址"
            }
            if indexPath.row == 1 {
                cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
                cell.textLabel.text = "我的优惠券"
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
                cell.textLabel.text = "告诉朋友"
            }
            if indexPath.row == 1 {
                cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
                cell.textLabel.text = "给好评"
            }
            if indexPath.row == 2 {
                cell = tableView.dequeueReusableCellWithIdentifier("userprotoclCell", forIndexPath: indexPath) as UITableViewCell
                cell.textLabel.text = "用户协议"
            }
            if indexPath.row == 3 {
                cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
                cell.textLabel.text = "版本升级"
            }
        }
        if indexPath.section == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel.text = "退出登录"
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2 {
            var userdefault = NSUserDefaults.standardUserDefaults()
            userdefault.setObject("", forKey: "userLog")
            headLabel.text = "立即登陆"
            tapGesture.enabled = true
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
