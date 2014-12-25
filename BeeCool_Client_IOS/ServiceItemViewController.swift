//
//  ServiceItemViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit
protocol serviceItemDelegate {
    func sendBackItem(str:NSString, tag:Int, price:Int)
}
class ServiceItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var servicedetailDictionary = NSDictionary()
    var array = NSMutableArray()
    var flag = Int()
    var delegate = serviceItemDelegate?()
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicedetailDictionary.count + 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("serviceItemCell", forIndexPath: indexPath) as UICollectionViewCell
        var textLabel = cell.contentView.viewWithTag(101) as UILabel
        var detailLabel = cell.contentView.viewWithTag(102) as UILabel
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.grayColor().CGColor
        var str = array.objectAtIndex(indexPath.row) as NSString
        if indexPath.row >= 1 {
        var price = (servicedetailDictionary[str as NSString] as NSDictionary)["价格"] as Int
        var info =  (servicedetailDictionary[str] as NSDictionary)["info"] as NSString
        detailLabel.text = NSString(format: "%d元一次", price)
        }
        textLabel.text = str
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= 1 {
           var str = array.objectAtIndex(indexPath.row) as NSString
            var price = (servicedetailDictionary[str as NSString] as NSDictionary)["价格"] as Int
        self.delegate?.sendBackItem(array.objectAtIndex(indexPath.row) as NSString, tag: flag, price:price)
        }else {
            self.delegate?.sendBackItem("无", tag: flag, price: 0)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        var length = collectionView.frame.width / 3
        return CGSizeMake(length, length)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        array.addObject("不需要")
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
