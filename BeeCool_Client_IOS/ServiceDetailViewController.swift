//
//  ServiceDetailViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, sendbackLocation{
    var maplocation = "请确定您车的位置"
    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func sendbackloc(str: NSString) {
        print(str)
        maplocation = str
        tableview.reloadData()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("typeCell", forIndexPath: indexPath) as UITableViewCell
    
        }
        if indexPath.section == 1 {
             cell = tableView.dequeueReusableCellWithIdentifier("mapCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel.text = maplocation
            cell.textLabel.textColor = UIColor.grayColor()
        }
        if indexPath.section == 2 {
            cell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel.text = "请选择服务人员"
           
            cell.textLabel.textColor = UIColor.grayColor()
        }
        if indexPath.section == 3 {
            cell = tableView.dequeueReusableCellWithIdentifier("staffCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel.text = "请选择服务时间"
            cell.imageView.image = UIImage(named: "time")
            cell.textLabel.textColor = UIColor.grayColor()

        }
        if indexPath.section == 4 {
            cell = tableView.dequeueReusableCellWithIdentifier("serviceCell", forIndexPath: indexPath) as UITableViewCell
          
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        }
        if indexPath.section == 4 {
            return 90
        }
        return 70
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var tableviewcell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        if collectionView == tableviewcell?.contentView.viewWithTag(101) as UICollectionView {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("carType", forIndexPath: indexPath) as UICollectionViewCell
            return cell
        }
       var cell = collectionView.dequeueReusableCellWithReuseIdentifier("carService", forIndexPath: indexPath) as UICollectionViewCell
       return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(70, 70)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapView" {
            (segue.destinationViewController as MapViewContrlloer).delegate = self
        }
    }
    
}
