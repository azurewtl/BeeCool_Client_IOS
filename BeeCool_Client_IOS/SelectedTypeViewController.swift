//
//  SelectedTypeViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class SelectedTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        var sectionArray = NSArray()
        var pathdic = NSDictionary()
        var backgroundView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.frame = view.frame
        backgroundView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        backgroundView.hidden = true
        self.view.addSubview(backgroundView)
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
        return sectionArray.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray.objectAtIndex(section) as NSString
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var str = sectionArray.objectAtIndex(section) as NSString
        var dic = pathdic.objectForKey(str) as NSDictionary
        var rowArray = NSMutableArray()
        for item in dic.allKeys {
            rowArray.addObject(item as NSString)
        }
        return rowArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
        return sectionArray
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
          var str = sectionArray.objectAtIndex(indexPath.section) as NSString
          var makeArray = (pathdic.objectForKey(str) as NSDictionary).allValues as NSArray
         var detailDictionary = makeArray.objectAtIndex(indexPath.row) as NSDictionary
        print(detailDictionary.allKeys)
        backgroundView.hidden = false
        backgroundView.bringSubviewToFront(view)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
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
