//
//  DetailOrderViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/23.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class DetailOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    override func viewDidLoad(){
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("detailorderCell") as UITableViewCell
        switch indexPath.row {
        case 0:
            cell.textLabel.text = "车类"
            cell.detailTextLabel?.text = "科尼赛克one"
        case 1:
            cell.textLabel.text = "地点"
            cell.detailTextLabel?.text = "蓝村路"
        case 2:
            cell.textLabel.text = "时间"
            cell.detailTextLabel?.text = "2014 － 12 － 24 －8:00"
        case 3:
            cell.textLabel.text = "业务员"
            cell.detailTextLabel?.text = "小董"
        case 4:
            cell.textLabel.text = "额外道具"
            cell.detailTextLabel?.text = "美孚"
        case 5:
            cell.textLabel.text = "总金额"
            cell.detailTextLabel?.text = "36元"
        default:
            cell.textLabel.text = ""
            
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
