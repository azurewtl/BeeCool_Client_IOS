//
//  LogViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/15.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var timeInterval = Int()
    var timer = NSTimer()
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        
        
        // Do any additional setup after loading the view.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func timeraction() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timegoing", userInfo: nil, repeats: true)
        timer.fire()
        
    }
    func timegoing() {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        var button = cell?.contentView.viewWithTag(102) as UIButton
        timeInterval++
        var text = (60 - timeInterval).description + "秒倒计时"
        if timeInterval > 60 {
            timer.invalidate()
            timeInterval = 0
            text = "超时,请重发"
            button.enabled = true
            button.backgroundColor = UIColor(red: 56 / 256.0, green: 94 / 256.0, blue: 15 / 256.0, alpha: 1)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        button.setTitle(text, forState: UIControlState.Normal)
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        print(textField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        var phoneTextFiled = cell?.contentView.viewWithTag(101) as UITextField
        var button = cell?.contentView.viewWithTag(102) as UIButton
        var phonestr =  NSMutableString(string: phoneTextFiled.text)
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as UITableViewCell?
        var verifyTextField = cell1?.contentView.viewWithTag(101) as UITextField
        let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as UITableViewCell?
        var button1 = cell2?.contentView.viewWithTag(101) as UIButton

        if phoneTextFiled .isFirstResponder() {
        if phonestr.length == 10 {
            button.enabled = true
            button.backgroundColor = UIColor(red: 56 / 256.0, green: 94 / 256.0, blue: 15 / 256.0, alpha: 1)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }else{
            button.setTitle("获取验证码", forState: UIControlState.Normal)
            button.backgroundColor = UIColor.grayColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.enabled = false
        }
        }else {
            if verifyTextField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 3 {
            button1.enabled = true
            button1.backgroundColor = UIColor(red: 56 / 256.0, green: 94 / 256.0, blue: 15 / 256.0, alpha: 1)
            button1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }else {
            button1.setTitle("验证", forState: UIControlState.Normal)
            button1.backgroundColor = UIColor.grayColor()
            button1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button1.enabled = false
        }
        }
        return true
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       var cell = UITableViewCell()
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("phoneCell") as UITableViewCell
            var button = cell.contentView.viewWithTag(102) as UIButton
            button.layer.masksToBounds = true
            button.enabled = false
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: "btnOnclick1:", forControlEvents: UIControlEvents.TouchUpInside)
            var textfiled = cell.contentView.viewWithTag(101) as UITextField
            textfiled.delegate = self
            textfiled.keyboardType = UIKeyboardType.PhonePad
        }
        if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("maskCell") as UITableViewCell
            var textfiled = cell.contentView.viewWithTag(101) as UITextField
            textfiled.delegate = self
            textfiled.keyboardType = UIKeyboardType.PhonePad
        }
        if indexPath.section == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("okCell") as UITableViewCell
            var button = cell.contentView.viewWithTag(101) as UIButton
            button.layer.masksToBounds = true
            button.enabled = false
             button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: "btnOnclick:", forControlEvents: UIControlEvents.TouchUpInside)
          
        }
        return cell
    }
    func btnOnclick1(sender:UIButton) {
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        var phoneTextField = cell?.contentView.viewWithTag(101) as UITextField
            Vertify.getphone(phoneTextField.text, block: { (var result:Int32) -> Void in
                if result == 1 {
                    sender.setTitle("获取成功", forState: UIControlState.Normal)
                    self.timeraction()
                    sender.backgroundColor = UIColor.grayColor()
                    sender.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    sender.enabled = false
                }else {
                    sender.setTitle("获取失败", forState: UIControlState.Normal)
                }

            })
        
        
    }
    func btnOnclick(sender:UIButton) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as UITableViewCell?
        var verifyTextField = cell?.contentView.viewWithTag(101) as UITextField
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        var phoneTextField = cell?.contentView.viewWithTag(101) as UITextField
        Vertify.getvertifynumber(verifyTextField.text) { (var result:Int32) -> Void in
            if result == 1 {
                sender.setTitle("验证成功", forState: UIControlState.Normal)
                sender.backgroundColor = UIColor.grayColor()
                sender.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                sender.enabled = false
                var userdefault = NSUserDefaults.standardUserDefaults()
                userdefault.setObject(phoneTextField.text, forKey: "userLog")
                self.navigationController?.popViewControllerAnimated(true)
             
            }else {
                sender.setTitle("验证失败", forState: UIControlState.Normal)
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
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
