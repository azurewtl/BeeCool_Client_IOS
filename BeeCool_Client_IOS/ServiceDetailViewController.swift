//
//  ServiceDetailViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPickerViewDataSource,UIPickerViewDelegate, sendbackLocation, carTypeDelegate, serviceItemDelegate,UIAlertViewDelegate{
    
    var serviceDictionary = NSDictionary()
    var maplocation = "请确定您车的位置"
    var actionsheetView = TimeActionSheet() // actionSheet
    var backgroundview = UIView() // actionSheetOption
    
    // For Order Time Selection // orderTimePicker
    var date = NSArray() // date
    var time = NSArray() // hour
    var timetoday = NSMutableArray() //hourToday
    var intertval = NSArray() // minute
    // For Vehical Selection
    var selectedVehical = NSIndexPath()
    var typecollectioncellCount = 1 // vehicleCollectionViewCount
    // For Additional Service
    var servicecollectioncellArray = NSMutableArray()//additinalServiceCollectionViewCount
    var serviceSegueArray = NSMutableArray()
    
    @IBOutlet var tableview: UITableView!
    func sendBackType() {
        typecollectioncellCount++
        let cell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        var collectionView = cell?.contentView.viewWithTag(101) as UICollectionView
        collectionView.reloadData()
    }
    func sendBackItem(str: NSString, tag: Int) {
        servicecollectioncellArray.replaceObjectAtIndex(tag, withObject: str)
        let cell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 4)) as UITableViewCell?
        var collectionView = cell?.contentView.viewWithTag(101) as UICollectionView
        var collectCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: tag, inSection: 0)) as UICollectionViewCell?
        collectCell?.layer.borderWidth = 1
        collectCell?.layer.borderColor = UIColor.greenColor().CGColor
        
        var label = collectCell?.contentView.viewWithTag(101) as UILabel
        label.textColor = UIColor.blackColor()
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: -下面弹出界面代码敲的
        var dic = serviceDictionary["additionalService"] as NSDictionary
        for item in dic.allKeys {
            servicecollectioncellArray.addObject(item)
            serviceSegueArray.addObject(item)
        }

        self.title = serviceDictionary["iconstr"] as NSString
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
        
    
        
        var nib = NSBundle.mainBundle().loadNibNamed("TimeActionSheet", owner: nil, options: nil) as NSArray
        actionsheetView = nib.objectAtIndex(0) as TimeActionSheet
        actionsheetView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, self.view.frame.height / 2)
        self.view.addSubview(actionsheetView)
        actionsheetView.bringSubviewToFront(backgroundview)
        actionsheetView.cancelButton.addTarget(self, action: "cancelOnclick", forControlEvents: UIControlEvents.TouchUpInside)
        actionsheetView.finishButton.addTarget(self, action: "finishOnclick", forControlEvents: UIControlEvents.TouchUpInside)
        actionsheetView.pickerView.dataSource = self
        actionsheetView.pickerView.delegate = self
        
    }
    func cancelOnclick() {
        actionsheethide()
        backgroundview.hidden = true
    }
    func finishOnclick() {
        var datestr = NSString()
        var timestr = NSString()
        let cell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))
        var daterow = actionsheetView.pickerView.selectedRowInComponent(0)
        var selectstr = date.objectAtIndex(daterow) as NSString
        var timerow = actionsheetView.pickerView.selectedRowInComponent(1)
        var intervalrow = actionsheetView.pickerView.selectedRowInComponent(2)
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
            self.actionsheetView.frame = CGRectMake(0, self.view.frame.height / 2, self.view.frame.width, self.view.frame.height / 2)
        })
        
    }
    func actionsheethide() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.actionsheetView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, self.view.frame.height / 2)
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
            var collectionView = cell.contentView.viewWithTag(101) as UICollectionView
            
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
            return 120
        }
       
        if indexPath.section == 4 {
            var height = ((servicecollectioncellArray.count / 4) + 1) * 90
            return CGFloat(height)

        }
        return 70
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           var headerview = UIView(frame: CGRectZero)
        if section == 0 {
            headerview.backgroundColor = UIColor(red: 245 / 256.0, green: 222 / 256.0, blue: 179 / 256.0, alpha: 1)
            var label = UILabel(frame: CGRectMake(0, 0, view.frame.width, 48))
            label.text = serviceDictionary["infoTitle"] as NSString
            label.textColor = UIColor.blackColor()
            label.textAlignment = NSTextAlignment.Center
            headerview.addSubview(label)
        }
    return headerview
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 48
        }
        return 0
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        if collectionView == cell!.contentView.viewWithTag(101) as UICollectionView{
         return typecollectioncellCount
        }
            return servicecollectioncellArray.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var tableviewcell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        if collectionView == tableviewcell?.contentView.viewWithTag(101) as UICollectionView {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("carType", forIndexPath: indexPath) as UICollectionViewCell
            cell.layer.borderWidth = 1
            var image = UIImage(named: "dashline")
            var color = UIColor(patternImage: image!)
            cell.layer.borderColor = color.CGColor
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            var press = UILongPressGestureRecognizer(target: self, action: "press:")
            cell.userInteractionEnabled = true
            if indexPath.item == selectedVehical.item {
                cell.layer.borderColor = UIColor.greenColor().CGColor
            }
        
            if indexPath.item == typecollectioncellCount - 1 {
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("addInfo", forIndexPath: indexPath) as UICollectionViewCell
                
            }else {
                  cell.addGestureRecognizer(press)
            }
            return cell
        
        }
     
       var cell = collectionView.dequeueReusableCellWithReuseIdentifier("carService", forIndexPath: indexPath) as UICollectionViewCell
        var label = cell.contentView.viewWithTag(101) as UILabel
        label.text = servicecollectioncellArray.objectAtIndex(indexPath.item) as NSString
       return cell
    }
    func press(longpress:UILongPressGestureRecognizer) {
        if longpress.state == UIGestureRecognizerState.Began {
        var alertview = UIAlertView(title: "提示", message: "确定要删除吗", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alertview.show()
        }
    }
    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let cell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
            var collectionView = cell?.contentView.viewWithTag(101) as UICollectionView
            typecollectioncellCount--
            collectionView.reloadData()
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let cell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        if collectionView == cell?.contentView.viewWithTag(101) as UICollectionView {
            let edgeLength = (self.view.frame.width - 40) / 3
            return CGSizeMake(edgeLength, edgeLength)
        }
        
        return CGSizeMake(70, 70)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var tableviewcell = tableview.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        if collectionView == tableviewcell?.contentView.viewWithTag(101) as UICollectionView {
        
        if indexPath.item == typecollectioncellCount - 1 {
            
        }else {
            for index in 0...typecollectioncellCount - 2 {
                var cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as UICollectionViewCell?
                var image = UIImage(named: "dashline")
                var color = UIColor(patternImage: image!)
                cell?.layer.borderColor = color.CGColor
            }
           selectedVehical = indexPath
            var cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: indexPath.item, inSection: 0)) as UICollectionViewCell?
            cell?.layer.borderColor = UIColor.greenColor().CGColor
        }
    }
        
}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapView" {
            (segue.destinationViewController as MapViewContrlloer).delegate = self
        }
        if segue.identifier == "typeView" {
            (segue.destinationViewController as CarTypeViewController).delegate = self
        }
        if segue.identifier == "serviceView" {
            var view = sender?.superview as UICollectionView
            var tag = view.indexPathForCell(sender as UICollectionViewCell)?.item
            var dic = serviceDictionary["additionalService"] as NSDictionary
            var str = serviceSegueArray.objectAtIndex(tag!) as NSString
            var dic1 = dic[str] as NSDictionary
            (segue.destinationViewController as ServiceItemViewController).servicedetailDictionary = dic1
            (segue.destinationViewController as ServiceItemViewController).title = str
            (segue.destinationViewController as ServiceItemViewController).delegate = self
            (segue.destinationViewController as ServiceItemViewController).flag = tag!
        }
    }
    
}
