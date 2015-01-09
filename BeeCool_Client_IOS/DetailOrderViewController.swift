//
//  DetailOrderViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/23.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit
class DetailOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    class Product: NSObject {
        private
        var price = Float()
        var subject = NSString()
        var body = NSString()
        var orderID = NSString()
    }
    var  selectedFlag = 3
    var productlist = NSMutableArray()
    @IBOutlet var nextButton: UIButton!
    
    
    @IBAction func nextStepOncick(sender: UIButton) {
        if selectedFlag == 0 {
            JSenPayEngine.sharePayEngine().wxPayAction()
        }
        if selectedFlag == 1 {
            var pro = productlist.objectAtIndex(0) as Product
            var partner = "2088611075948671"
            var seller = "support@xxx.com"
            var privatekey = "MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBANJR7UFPe0rExR9/27CDaQqer5wHESBtE80hr10CoqBd8PAvdXqjxTc9/BGFk6lMggTQKNMGmI5Vvr8ZuJZq3tpR8S70ri6381iL0egPAlAwmEcjSRUswEV7wwL3edHvhAm443DKk2l00hkhfUaEiJGTs9cXqMQ+ykHHfIVUFdqdAgMBAAECgYEAz2SsUVfAG0WXoG0jRJcA0NEUGAa787675O7PjycXGI4qFZ6m+O1ffw7nbpvKtQpVt8tQRm9dphWVh7okVGdEIje5+Qd9lOdWd5MvN/cwOlD2BPy8EzE4S3QhsBxgqq8dqDh7R5p/2LwcuaaPlVmIMITZvEYMFohRpMPamXGIwT0CQQD75MLzCjberDnt2UkUo8sWHYwaAYmIXqB0EIRKFvswhLvlrRw9kymJcMyI8UDBXgxJmUl5sZ01rwp8e2/SsYVTAkEA1b+qGiaUPulsRq0uXjqwFkBZVNVZVhF5DsqZNb1JjcTHOBC5pPkbQ/wl4HnA1sfH3Pjx5QeuRfSTtWBA4JoSTwJBAJKSt9nijLEfuImtkTfgY5FX2ilb0aK3pVhEMCZInxvJcOihxbgSxO3D5FCfSZX7Wt0MxFN6xcbyNwDeduA8Ch8CQQC70d3zeqDbIxssg3JyBFnEQ6j7XTlR 4qqgL7Auw3RFaXqwrimiZ+3ocEEMHZAwan4ZknpjiLs+5yl/v+NiOKALAkEA8hLs UMy+jrkm9yoOOzufpgkOvts/BBO4GD7BQynv1lMK9dvBO9jYV0ACBca965gR6c7vi5cJ5ROn6X7DXcMngg=="
            if partner.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || seller.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
                var alert = UIAlertView(title: "提示", message: "缺少id", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }else {
                var order = Order()
                order.partner = partner
                order.seller = seller
                order.tradeNO = generateTradeNO()
                order.productName = pro.subject
                order.productDescription = pro.body
                order.amount = pro.price.description
                order.notifyURL = "www.sxsx.com"
                order.service = "mobile.security.pay"
                order.paymentType = "1"
                order.inputCharset = "utf-8"
                order.itBPay = "30m"
                order.showUrl = "m.alipay.com"
                
                var appScheme = "alisdkdemo"
                var orderSpec = order.description
                //        print(orderSpec)
                var signer = CreateRSADataSigner(privatekey) as DataSigner
                var signedstr = signer.signString(orderSpec)
                var orderstr = nil as NSString?
                //        if signedstr != nil {
                orderstr = NSString(format: "%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, "","RSA")
                AlipaySDK.defaultService().payOrder(orderstr, fromScheme: appScheme, callback: { (result) -> Void in
                    print(result as NSDictionary)
                    //                9000代表支付成功
                    //                8000正在处理
                    //                4000失败
                    //                6001用户中途取消
                    //                6002网络出错
                })
                //            }
            }
        }
        if selectedFlag == 2 {
            self.navigationController?.popViewControllerAnimated(true)
        }
        if selectedFlag == 3 {
            var alert = UIAlertView(title: "提示", message: "请选择支付方式", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            
        }
    }
    
    
    func generateTradeNO() -> NSString {
        var knumber = 15
        var sourcestr = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" as NSString
        var result = NSMutableString()
        srand(UInt32(time(nil)))
        for(var i = 0;i < knumber;i++) {
            var index = Int(rand()) % sourcestr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            let s = sourcestr.substringWithRange(NSMakeRange(index, 1))
            result.appendString(s)
        }
        return result
    }
    func generateData() {
        var subjects = ["精致洗车"] as NSArray
        var body = ["总价钱36元"] as NSArray
        if productlist == [] {
            productlist = NSMutableArray()
        }else {
            productlist.removeAllObjects()
        }
        for index in 0...subjects.count - 1 {
            var product = Product()
            product.subject = subjects.objectAtIndex(index) as NSString
            product.body = body.objectAtIndex(index) as NSString
            product.price = Float(arc4random() % 100)
            productlist.addObject(product)
        }
        
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 5
        generateData()
        // Do any additional setup after loading the view.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return 6
        }
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("detailorderCell") as UITableViewCell
        if indexPath.section == 0 {
        switch indexPath.row {
        case 0:
            cell.textLabel.text = "车类"
            cell.detailTextLabel?.text = "科尼赛克one"
            
        case 1:
            cell.textLabel.text = "地点"
            cell.detailTextLabel?.text = "蓝村路"
        case 2:
            cell.textLabel.text = "时间"
            cell.detailTextLabel?.text = "2014 － 12 － 24 －8:00"
        case 3:
            cell.textLabel.text = "业务员"
            cell.detailTextLabel?.text = "小董"
        case 4:
            cell.textLabel.text = "额外道具"
            cell.detailTextLabel?.text = "美孚"
        case 5:
            cell.textLabel.text = "总金额"
            cell.detailTextLabel?.text = "36元"
        default:
            cell.textLabel.text = ""
            
        }
        }else {
            switch indexPath.row {
            case 0:
            cell.textLabel.text = "微信支付"
            case 1:
            cell.textLabel.text = "支付宝支付"
            case 2:
            cell.textLabel.text = "余额支付"
            default:
            cell.textLabel.text = ""
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as UITableViewCell?
            let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as UITableViewCell?
            let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1)) as UITableViewCell?
            if indexPath.row == 0 {
                selectedFlag = 0
               cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
               cell1?.accessoryType = UITableViewCellAccessoryType.None
               cell2?.accessoryType = UITableViewCellAccessoryType.None
            }
            if indexPath.row == 1 {
                selectedFlag = 1
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell1?.accessoryType = UITableViewCellAccessoryType.Checkmark
                cell2?.accessoryType = UITableViewCellAccessoryType.None
            }
            if indexPath.row == 2 {
                selectedFlag = 2
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell1?.accessoryType = UITableViewCellAccessoryType.None
                cell2?.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "详细信息"
        }
        return "选择支付"
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
