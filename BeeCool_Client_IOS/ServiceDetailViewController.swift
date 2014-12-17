//
//  ServiceDetailViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPickerViewDataSource,UIPickerViewDelegate, sendbackLocation{
    var maplocation = "请确定您车的位置"
    var sheetView = UIView()
    var backgroundview = UIView()
    var pickerView = UIPickerView()
    var date = NSArray()
    var time = NSArray()
    var timetoday = NSMutableArray()
    var intertval = NSArray()
    
    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: -下面弹出界面代码敲的
        var nowdate = NSDate(timeIntervalSinceNow: 8 * 60 * 60)
        var strr = NSString(format: "%@", nowdate)
        var strarr = strr.componentsSeparatedByString(" ") as NSArray
        var strValue = ((strarr.objectAtIndex(1) as NSString).componentsSeparatedByString(":") as NSArray).firstObject as NSString
        date = ["今天", "明天"] as NSArray
        time = ["9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21"] as NSArray
        for item in time {
            if (item as NSString).integerValue > strValue.integerValue {
                timetoday.addObject(item as NSString)
            }
            
        }
        intertval = ["00分", "30分"] as NSArray
        self.tabBarController?.tabBar.hidden = true
        backgroundview = UIView(frame: self.view.bounds)
        self.view.addSubview(backgroundview)
        backgroundview.hidden = true
        backgroundview.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        backgroundview.bringSubviewToFront(self.view)
        self.sheetView = UIView(frame: CGRectMake(0, self.view.frame.height, self.view.frame.width, self.view.frame.height / 2))
        sheetView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(sheetView)
        sheetView.bringSubviewToFront(backgroundview)
        var topView = UIView(frame: CGRectMake(0, 0, sheetView.frame.width , sheetView.frame.height / 5))
        sheetView.addSubview(topView)
        topView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        var cancelButtton = UIButton(frame: CGRectMake(0, 0, topView.frame.width / 5, topView.frame.height))
        cancelButtton.setTitle("取消", forState: UIControlState.Normal)
        cancelButtton.backgroundColor = UIColor.whiteColor()
        cancelButtton.setTitleColor(UIColor.cyanColor(), forState: UIControlState.Normal)
        cancelButtton.addTarget(self, action: "cancelOnclick", forControlEvents: UIControlEvents.TouchUpInside)
        sheetView.addSubview(cancelButtton)
        var titleLabel = UILabel(frame: CGRectMake(cancelButtton.frame.width, 0, 0.6 * topView.frame.width, topView.frame.height))
        titleLabel.text = "请选择"
        titleLabel.textAlignment = NSTextAlignment.Center
        sheetView.addSubview(titleLabel)
        var finishButtton = UIButton(frame: CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.width, 0, topView.frame.width / 5, topView.frame.height))
        finishButtton.backgroundColor = UIColor.whiteColor()
        finishButtton.setTitleColor(UIColor.cyanColor(), forState: UIControlState.Normal)
        finishButtton.setTitle("确定", forState: UIControlState.Normal)
        finishButtton.addTarget(self, action: "finishOnclick", forControlEvents: UIControlEvents.TouchUpInside)
        sheetView.addSubview(finishButtton)
        pickerView = UIPickerView(frame: CGRectMake(0, topView.frame.height, topView.frame.width, sheetView.frame.height - topView.frame.height))
        pickerView.dataSource = self
        pickerView.delegate = self
        sheetView.addSubview(pickerView)
    }
    func cancelOnclick() {
        actionsheethide()
        backgroundview.hidden = true
    }
    func finishOnclick() {
        var datestr = NSString()
        var timestr = NSString()
        let cell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))
        var daterow = pickerView.selectedRowInComponent(0)
        var selectstr = date.objectAtIndex(daterow) as NSString
        var timerow = pickerView.selectedRowInComponent(1)
        var intervalrow = pickerView.selectedRowInComponent(2)
        var nowdate = NSDate(timeIntervalSinceNow: 8 * 60 * 60)
        var tomorrowdate = NSDate(timeIntervalSinceNow: 32 * 60 * 60)
        var nowformatter = NSDateFormatter()
        nowformatter.dateStyle = NSDateFormatterStyle.FullStyle
        if selectstr == "今天" {
            
            datestr = nowformatter.stringFromDate(nowdate)
            timestr = timetoday.objectAtIndex(timerow) as NSString
        }else {
            
            datestr = nowformatter.stringFromDate(tomorrowdate)
            timestr = time.objectAtIndex(timerow) as NSString
        }
        var intervalstr = intertval.objectAtIndex(intervalrow) as NSString
        cell?.textLabel.text = NSString(format: "%@ %@:%@", datestr, timestr, intervalstr)
        actionsheethide()
        backgroundview.hidden = true
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        actionsheethide()
        backgroundview.hidden = true
    }
    func actionsheetshow() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.sheetView.frame = CGRectMake(0, self.view.frame.height / 2, self.view.frame.width, self.view.frame.height / 2)
        })
        
    }
    func actionsheethide() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.sheetView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, self.view.frame.height / 2)
        })
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
           return date.count
        }
        if component == 1 {
            let row1 = pickerView.selectedRowInComponent(0)
            if date.objectAtIndex(row1) as NSString == "今天" {
                return timetoday.count
            }
            return time.count
        }
        if component == 2 {
            return intertval.count
        }
        return 0
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
           return date.objectAtIndex(row) as NSString
           
        }
        if component == 1 {
            let row1 = pickerView.selectedRowInComponent(0)
            if date.objectAtIndex(row1) as NSString == "今天" {
                return NSString(format:"%@时", timetoday.objectAtIndex(row) as NSString)
            }
           return NSString(format:"%@时", time.objectAtIndex(row) as NSString)
        }
        if component == 2 {
          return intertval.objectAtIndex(row) as NSString
        }
        return ""
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
    //MARK: -代码敲的结束
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
            cell.textLabel.text = "请选择服务时间"
            cell.imageView.image = UIImage(named: "time")
            cell.textLabel.textColor = UIColor.grayColor()
        }
        if indexPath.section == 3 {
            cell = tableView.dequeueReusableCellWithIdentifier("staffCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel.text = "请选择服务人员"
            cell.textLabel.textColor = UIColor.grayColor()

        }
        if indexPath.section == 4 {
            cell = tableView.dequeueReusableCellWithIdentifier("serviceCell", forIndexPath: indexPath) as UITableViewCell
          
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2 {
            actionsheetshow()
            backgroundview.hidden = false
        }
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
