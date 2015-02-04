//
//  CarTypeViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit
protocol carTypeDelegate {
    func sendBackType(carName:NSString, carID:NSString, carColor:NSString)
}
class CarTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, sendcarDelegate, UITextFieldDelegate {
    var backgroundview = UIView()
    
    var typeName:NSString = "请选择车类型"
    var selectedFlag = Int()
    var collectionView = UICollectionView?()
    var delegate = carTypeDelegate?()
    var array = NSArray()
    @IBOutlet var tableView: UITableView!
    @IBAction func finishedOnclick(sender: UIBarButtonItem) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as UITableViewCell?
        var textfiled = cell1?.contentView.viewWithTag(102) as UITextField
        var button = cell1?.contentView.viewWithTag(101) as UIButton
        let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as UITableViewCell?
        var textfield1 = cell2?.contentView.viewWithTag(102) as UITextField
        var str = cell?.textLabel.text
        var str1 = NSString(format: "%@%@", button.currentTitle!, textfiled.text)
        var str2 = textfield1.text
        if textfiled.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 6 {
            var alert = UIAlertView(title: "提示", message: "请输入正确的车牌号", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }else {
        self.delegate?.sendBackType(str!, carID: str1, carColor: str2)
        self.navigationController?.popViewControllerAnimated(true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundview = UIView(frame: self.view.bounds)
        self.view.addSubview(backgroundview)
        backgroundview.hidden = true
        backgroundview.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        backgroundview.bringSubviewToFront(self.view)
        array = ["京", "浙", "津", "皖", "沪", "闽", "渝", "赣", "港", "鲁", "澳", "豫", "蒙", "鄂", "新", "湘", "宁", "粤", "藏", "琼", "桂", "川", "冀", "贵", "晋",  "云", "辽", "陕", "吉", "甘", "黑", "青", "苏", "台"] as NSArray
        var layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
       self.collectionView = UICollectionView(frame: CGRectMake(0, view.frame.height, view.frame.width, view.frame.height / 3), collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.registerClass(ProvinceCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "provinceCell")
        self.view.addSubview(collectionView!)
        // Do any additional setup after loading the view.
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        backgroundview.hidden = true
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.collectionView!.frame = CGRectMake(0,  self.view.frame.height , self.view.frame.width, self.view.frame.height
                / 3)
        })

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("carCell") as UITableViewCell
            cell.imageView.image = UIImage(named: "car")
            cell.textLabel.text = typeName
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                
                cell = tableView.dequeueReusableCellWithIdentifier("caridCell") as UITableViewCell
                cell.textLabel.text = "车牌号："
                var carIDTextField = cell.contentView.viewWithTag(102) as UITextField
                carIDTextField.delegate = self
                carIDTextField.keyboardType = UIKeyboardType.ASCIICapable
                
            }
            if indexPath.row == 1 {
                cell = tableView.dequeueReusableCellWithIdentifier("carcolorCell") as UITableViewCell
                cell.textLabel.text = "车的颜色▼："
                var carColorTextField = cell.contentView.viewWithTag(102) as UITextField
                carColorTextField.delegate = self
            }
        }
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            if indexPath.row == 0 {
            selectedFlag = 1
                array = ["京", "浙", "津", "皖", "沪", "闽", "渝", "赣", "港", "鲁", "澳", "豫", "蒙", "鄂", "新", "湘", "宁", "粤", "藏", "琼", "桂", "川", "冀", "贵", "晋",  "云", "辽", "陕", "吉", "甘", "黑", "青", "苏", "台"] as NSArray
            collectionView?.reloadData()
            backgroundview.hidden = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.collectionView!.frame = CGRectMake(0, 2 * self.view.frame.height / 3, self.view.frame.width, self.view.frame.height
                 / 3)
            })
            }
            if indexPath.row == 1 {
                selectedFlag = 2
                array = ["黑", "白", "银", "红", "蓝", "黄", "钛灰"] as NSArray
                collectionView?.reloadData()
                backgroundview.hidden = false
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.collectionView!.frame = CGRectMake(0, 2 * self.view.frame.height / 3, self.view.frame.width, self.view.frame.height
                        / 3)
                })
            }
        }
      
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "请输入车辆信息"
        }
        return ""
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("provinceCell", forIndexPath: indexPath) as ProvinceCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.label.text = array.objectAtIndex(indexPath.row) as NSString
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        var size = self.view.frame.width / 6
        return CGSizeMake(size, size)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as UITableViewCell?
        var button = cell?.viewWithTag(101) as UIButton
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as UITableViewCell?
        var textfield = cell1?.viewWithTag(102) as UITextField
        if selectedFlag == 1 {
        button.setTitle(array.objectAtIndex(indexPath.item) as NSString, forState: UIControlState.Normal)
        }
        if selectedFlag == 2 {
         textfield.text = array.objectAtIndex(indexPath.item) as NSString
        }
        backgroundview.hidden = true
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.collectionView!.frame = CGRectMake(0,  self.view.frame.height , self.view.frame.width, self.view.frame.height
                / 3)
        })
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as SelectedTypeViewController).delegate = self
    }
    func sendCarName(str: NSString) {
        typeName = str
        tableView.reloadData()
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
