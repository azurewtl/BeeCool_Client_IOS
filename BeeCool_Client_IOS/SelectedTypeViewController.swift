//
//  SelectedTypeViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit
protocol sendcarDelegate{
    func sendCarName(str:NSString)
}
class SelectedTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        var sectionArray = NSArray()
        var detailrowArray = NSArray()
        var pathdic = NSDictionary()
        var backgroundView = UIView()
        var sliderView = DetailCarView()
        var delegate = sendcarDelegate?()
    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = NSBundle.mainBundle().loadNibNamed("DetailCarView", owner: nil, options: nil) as NSArray
        sliderView = nib.objectAtIndex(0) as DetailCarView
        sliderView.frame = CGRectMake(view.frame.width, 64, 2 * view.frame.width / 3, view.frame.height - 64)
       
        sliderView.detailTableView.delegate = self
        sliderView.detailTableView.dataSource = self
        sliderView.detailTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "detailTypeCell")
        backgroundView.frame = view.frame
        backgroundView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        backgroundView.hidden = true
        self.view.addSubview(backgroundView)
         view.addSubview(sliderView)
        var path = NSBundle.mainBundle().pathForResource("car", ofType: "json")
        var data1 = NSData(contentsOfFile: path!)
        pathdic = NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        var arr =  NSMutableArray()
        for item in pathdic.allKeys {
            arr.addObject(item as NSString)
        }
        sectionArray = arr.sortedArrayUsingSelector(Selector("compare:"))

        
        // Do any additional setup after loading the view.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == sliderView.detailTableView {
            return 1
        }
        return sectionArray.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == sliderView.detailTableView {
           return ""
        }
        return sectionArray.objectAtIndex(section) as NSString
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sliderView.detailTableView {
            return detailrowArray.count
        }
        var str = sectionArray.objectAtIndex(section) as NSString
        var dic = pathdic.objectForKey(str) as NSDictionary
        var rowArray = NSMutableArray()
        for item in dic.allKeys {
            rowArray.addObject(item as NSString)
        }
        return rowArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == sliderView.detailTableView {
          var cell = tableView.dequeueReusableCellWithIdentifier("detailTypeCell") as UITableViewCell
          cell.textLabel.text = detailrowArray.objectAtIndex(indexPath.row) as NSString
          return cell
        }
        var cell = tableView.dequeueReusableCellWithIdentifier("makeCell") as UITableViewCell
        var str = sectionArray.objectAtIndex(indexPath.section) as NSString
        var dic = pathdic.objectForKey(str) as NSDictionary
        var rowArray = NSMutableArray()
        for item in dic.allKeys {
            rowArray.addObject(item as NSString)
        }
        cell.textLabel.text = rowArray.objectAtIndex(indexPath.row) as NSString
        return cell
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        if tableView == sliderView.detailTableView {
            return nil
        }
        return sectionArray
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == sliderView.detailTableView {
            var name = NSString(format:"%@-%@", sliderView.titleLabel.text!, detailrowArray.objectAtIndex(indexPath.row) as NSString)
            self.delegate?.sendCarName(name)
            self.sliderView.frame = CGRectMake(self.view.frame.width, 64, self.sliderView.frame.width, self.sliderView.frame.height)
            self.navigationController?.popViewControllerAnimated(true)
        }else {
        var str = sectionArray.objectAtIndex(indexPath.section) as NSString
        var makeArray = (pathdic.objectForKey(str) as NSDictionary).allValues as NSArray
        var detailDictionary = makeArray.objectAtIndex(indexPath.row) as NSDictionary
        print(detailDictionary.allKeys)
        detailrowArray = detailDictionary.allKeys as NSArray
        sliderView.detailTableView.reloadData()
        backgroundView.hidden = false
        backgroundView.bringSubviewToFront(view)
        sliderView.titleLabel.text = ((pathdic.objectForKey(str) as NSDictionary).allKeys as NSArray).objectAtIndex(indexPath.row) as NSString
        sliderView.bringSubviewToFront(backgroundView)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.sliderView.frame = CGRectMake(self.view.frame.width / 3, 64, self.sliderView.frame.width, self.sliderView.frame.height)
        })
        }
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.sliderView.frame = CGRectMake(self.view.frame.width, 64, self.sliderView.frame.width, self.sliderView.frame.height)
        })
        backgroundView.hidden = true
        
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
