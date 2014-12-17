//
//  FirstViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/16.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIScrollViewDelegate {

    @IBAction func pagesender(sender: UIPageControl) {
        
        var viewsize = scrollView.frame.size
        scrollView.contentOffset = CGPointMake(CGFloat(sender.currentPage) * viewsize.width, 0)
    }
    @IBOutlet var pageControll: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var enterOnclick: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        enterOnclick.layer.masksToBounds = true
        enterOnclick.layer.cornerRadius = 5
        enterOnclick.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        var scrollwidth = self.view.frame.width
        var scrollheight = self.view.frame.height
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(4 * scrollwidth, 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        for index in 0...3 {
            var imageview = UIImageView(frame: CGRectMake(CGFloat(index) * scrollwidth, 0, scrollwidth, scrollheight))
            var str = NSString(format: "%d.jpg", index)
            imageview.image = UIImage(named: str)
            scrollView.addSubview(imageview)
        }
        pageControll.currentPage = 0
        
        
        // Do any additional setup after loading the view.
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset
        var bounds = scrollView.frame
        pageControll.currentPage = Int(offset.x / bounds.width)

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
