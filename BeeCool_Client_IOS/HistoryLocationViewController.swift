//
//  HistoryLocationViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class HistoryLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell") as UITableViewCell
        cell.textLabel.font = UIFont.boldSystemFontOfSize(14)
        cell.textLabel.text = "上海南站"
        cell.detailTextLabel?.text = "15号楼地下停车场"
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
