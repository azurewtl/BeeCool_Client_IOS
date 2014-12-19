//
//  ServiceItemViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class ServiceItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var servicedetailDictionary = NSDictionary()
    var array = NSMutableArray()
    @IBAction func completeOnclick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("serviceitemCell") as UITableViewCell
        print(array.objectAtIndex(indexPath.row))
        var str = array.objectAtIndex(indexPath.row) as NSString
        var price = (servicedetailDictionary[str as NSString] as NSDictionary)["价格"] as Int
        var info =  (servicedetailDictionary[str] as NSDictionary)["info"] as NSString
        cell.textLabel.text = NSString(format: "%@, %d块钱一次", str, price)
        cell.detailTextLabel?.text = info
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicedetailDictionary.count
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        for item in servicedetailDictionary.allKeys{
            array.addObject(item)
        }
        // Do any additional setup after loading the view.
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
