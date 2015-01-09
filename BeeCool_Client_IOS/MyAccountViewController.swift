//
//  MyAccountViewController.swift
//  BeeCool
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tableheaderView: UIView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet var headImageView: UIImageView!
    @IBOutlet var headLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarItem.badgeValue = nil
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NVG1"), forBarMetrics: UIBarMetrics.Default)

        var locatios:[CGFloat] = [0.1, 0.9]
        var colors = [UIColor.yellowColor().CGColor, UIColor.greenColor().CGColor]
        var colorspace = CGColorSpaceCreateDeviceRGB()
       var gradient = CGGradientCreateWithColors(colorspace, colors, locatios)
        let bitmapinfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        var bitmapContext =  CGBitmapContextCreate(nil, 420, UInt(tableheaderView.frame.height), 8, 4 * 420, CGColorSpaceCreateDeviceRGB(), bitmapinfo)
        var start = CGPointMake(0, 0)
        var end = CGPointMake(420, tableheaderView.frame.height)
        CGContextDrawLinearGradient(bitmapContext, gradient, start, end, 0)
        var cgImage = CGBitmapContextCreateImage(bitmapContext)
        var image = UIImage(CGImage: cgImage)
        tableheaderView.backgroundColor = UIColor(patternImage: image!)
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
                cell.textLabel.text = "账户余额"
                cell.imageView.image = UIImage(named: "money")
            }
            if indexPath.row == 1 {
                cell = tableView.dequeueReusableCellWithIdentifier("youhuiCell", forIndexPath: indexPath) as UITableViewCell
                cell.imageView.image = UIImage(named:"you")
            var str = NSString(format: "已有%d张", 1)
            var attribute = NSMutableAttributedString(string: str)
            attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(2, 1))
                cell.detailTextLabel?.attributedText = attribute
            }
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
                cell.textLabel.text = "告诉朋友"
                cell.imageView.image = UIImage(named: "share")
            }
            if indexPath.row == 1 {
                cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
                cell.textLabel.text = "给好评"
                cell.imageView.image = UIImage(named: "comment")
            }
            if indexPath.row == 2 {
                cell = tableView.dequeueReusableCellWithIdentifier("userprotoclCell", forIndexPath: indexPath) as UITableViewCell
                cell.textLabel.text = "用户协议"
                cell.imageView.image = UIImage(named: "protocol")
            }
            if indexPath.row == 3 {
                cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
                cell.textLabel.text = "版本升级"
                cell.imageView.image = UIImage(named: "update")
            }
        }
        if indexPath.section == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel.text = "退出登录"
            cell.imageView.image = UIImage(named: "shezhi")
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                var alert = UIAlertView(title: "提示", message: "亲, 您还剩1000元", delegate: nil, cancelButtonTitle: "关闭")
                alert.show()
            }
        }
        
        
        var imagepath = NSBundle.mainBundle().pathForResource("home", ofType: "jpg")
        if indexPath.section == 1{
            if indexPath.row == 0 {
                var publishContent = ShareSDK.content("贝库洗车，值得拥有官网 http://www.beikool.com", defaultContent: "贝库", image: ShareSDK.imageWithPath(imagepath), title: "bee cool", url: "http://www.beikool.com", description: "bee cool", mediaType: SSPublishContentMediaTypeNews)
                ShareSDK.showShareActionSheet(nil, shareList: nil, content: publishContent, statusBarTips: true, authOptions: nil, shareOptions: nil, result: { (var type:ShareType, var state:SSResponseState, var info:ISSPlatformShareInfo?, var error:ICMErrorInfo?, var end:Bool) -> Void in
                    
                    if Int(state.value) == 2{
                        var alert = UIAlertView(title: "提示", message: "分享失败", delegate: nil, cancelButtonTitle: "确定")
                        alert.show()
                    }else if Int(state.value) == 1 {
                        var alert = UIAlertView(title: "提示", message: "分享成功", delegate: nil, cancelButtonTitle: "确定")
                        alert.show()
                    }
                })
            }
        }
        
        
        if indexPath.section == 2 {
            var userdefault = NSUserDefaults.standardUserDefaults()
            var str = userdefault.objectForKey("userLog") as NSString
            if str == "" {
                var alert = UIAlertView(title: "温馨提示", message: "您还未登录！", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
            userdefault.setObject("", forKey: "userLog")
            headLabel.text = "立即登陆"
            tapGesture.enabled = true
          
        

        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "youhui" {
        (segue.destinationViewController as YouHuiTableViewController).useCount = 0
        }
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
