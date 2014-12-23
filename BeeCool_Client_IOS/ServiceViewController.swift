//
//  FirstViewController.swift
//  BeeCool
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate{
    var alert = UIAlertView()
    var array = NSMutableArray()
    @IBAction func teleOnclick(sender: UIBarButtonItem) {
        var phone = "15590285730"
        alert = UIAlertView(title: "提示", message: phone, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
    }
    
    @IBOutlet var serverCollectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var path1 = NSBundle.mainBundle().pathForResource("service", ofType:"json")
        var data1 = NSData(contentsOfFile: path1!)
        var arr = NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
        for item in arr {
           array.addObject((item as NSDictionary))
        }
        
//        array = ["精致洗车", "轮毂翻新", "精细护理", "高端养护", "抛光", "发动机清洗", "全部服务", "意见反馈","上海"] as NSArray
        var Autoscroll = AutoScrollView(frame: CGRectMake(0, -64, self.view.frame.width, 184))
        Autoscroll.imageUrls = ["http://m.meilijia.com/images/activity/rjds/m/banner-s.jpg", "http://www.meilijia.com/images/ad/iphone/1.jpg?v=0723", "http://m.meilijia.com/images/activity/rjds/m/banner.jpg"]
        Autoscroll.timeInterval = 3
        serverCollectionview.addSubview(Autoscroll)
        Autoscroll.setTarget(self, action: "autoAction:")
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
    }
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            var phone = "15590285730"
            var str = NSString(format:"tel://%@", phone)
            var url = NSURL(string: str)
            UIApplication.sharedApplication().openURL(url!)
            alert = UIAlertView(title: "提示", message: "未安装SM卡", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    func autoAction(tap:Tap) {
        print(tap.flag)
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("serviceCell", forIndexPath: indexPath) as UICollectionViewCell
        cell.layer.borderWidth = 1;
        var label = cell.contentView.viewWithTag(101) as UILabel
        label.text = (array.objectAtIndex(indexPath.row) as NSDictionary)["iconstr"] as NSString
        cell.layer.borderColor = UIColor.grayColor().CGColor
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        var width:CGFloat = 1 / 3
        width = width * self.view.frame.width
    return CGSizeMake(width, width)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(120, 0, 0, 0)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     var view = sender?.superview as UICollectionView
     var tag = view.indexPathForCell(sender as UICollectionViewCell)?.item
        if segue.identifier == "serviceDetail" {
            (segue.destinationViewController as ServiceDetailViewController).serviceDictionary = array.objectAtIndex(tag!) as NSDictionary
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}

