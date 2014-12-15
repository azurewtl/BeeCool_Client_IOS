//
//  CarTypeViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class CarTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    @IBAction func finishedOnclick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("carCell") as UITableViewCell
            cell.imageView.image = UIImage(named: "car")
            cell.textLabel.text = "请选择车的类型"
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("caridCell") as UITableViewCell
            cell.textLabel.text = "车牌号："
            }
            if indexPath.row == 1 {
                cell = tableView.dequeueReusableCellWithIdentifier("carcolorCell") as UITableViewCell
                cell.textLabel.text = "车的颜色："
            }
        }
        return cell
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "请输入车辆信息"
        }
        return ""
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
