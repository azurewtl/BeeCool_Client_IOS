//
//  ServiceDetailViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("detail", forIndexPath: indexPath) as UITableViewCell
        if indexPath.section == 0 {
            cell.textLabel.text = "请选择您的爱车"
            cell.textLabel.textColor = UIColor.grayColor()
        }
        if indexPath.section == 1 {
            cell.textLabel.text = "请确定您车的位置"
            cell.textLabel.textColor = UIColor.grayColor()
        }
        if indexPath.section == 2 {
            cell.textLabel.text = "请选择服务时间"
            cell.imageView.image = UIImage(named: "time")
            cell.textLabel.textColor = UIColor.grayColor()
        }
        return cell
    }
    
}
