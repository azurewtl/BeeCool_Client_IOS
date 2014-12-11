//
//  FirstViewController.swift
//  BeeCool
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    
    @IBOutlet var serverCollectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var Autoscroll = AutoScrollView(frame: CGRectMake(0, -64, self.view.frame.width, 184))
        Autoscroll.imageUrls = ["http://m.meilijia.com/images/activity/rjds/m/banner-s.jpg", "http://www.meilijia.com/images/ad/iphone/1.jpg?v=0723", "http://m.meilijia.com/images/activity/rjds/m/banner.jpg"]
        Autoscroll.timeInterval = 3
        serverCollectionview.addSubview(Autoscroll)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("serviceCell", forIndexPath: indexPath) as UICollectionViewCell
        cell.layer.borderWidth = 1;
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}

