//
//  UserprotocolViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/16.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class UserprotocolViewController: UIViewController{

    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        var path = NSBundle.mainBundle().pathForResource("userprotocol", ofType:"docx")
        print(path)
        var url = NSURL(string: path!)
        var request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        // Do any additonal setup after loading the view.
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
