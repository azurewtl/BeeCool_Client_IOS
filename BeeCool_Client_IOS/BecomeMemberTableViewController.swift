//
//  BecomeMemberTableViewController.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/23.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit

class BecomeMemberTableViewController: UITableViewController {
    class Product: NSObject {
    private
        var price = Float()
        var subject = NSString()
        var body = NSString()
        var orderID = NSString()
    }
    var productlist = NSMutableArray()
    var selectFlag = Int()
    @IBAction func nextstepOnclick(sender: UIButton) {
        if selectFlag == 0 {
            JSenPayEngine.sharePayEngine().wxPayAction()
        }
        if selectFlag == 1{
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
        if selectFlag == 2 {
            print("上门办理")
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
        var subjects = ["1000"] as NSArray
        var body = ["送100"] as NSArray
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
    override func viewDidLoad() {
        super.viewDidLoad()
        generateData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let usercell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        usercell?.textLabel.text = "充值账户"
        let moneycell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as UITableViewCell?
        moneycell?.textLabel.text = "充值金额"
        let goodcell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as UITableViewCell?
        goodcell?.textLabel.text = "反现金额"
        let weixincell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as UITableViewCell?
        weixincell?.textLabel.text = "微信支付"
        let alicell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as UITableViewCell?
        alicell?.textLabel.text = "支付宝支付"
        let poscell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1)) as UITableViewCell?
        poscell?.textLabel.text = "上门办理"
        poscell?.detailTextLabel?.text =  "支持现金,POS机刷卡,支票支付"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
       
        return 3
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "确认信息"
        }
        return "充值方式"
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            for index in 0...2 {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1)) as UITableViewCell?
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }
            let selectCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?
            selectFlag = indexPath.row
            selectCell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
