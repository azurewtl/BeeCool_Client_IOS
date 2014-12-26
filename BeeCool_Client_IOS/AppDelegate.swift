//
//  AppDelegate.swift
//  BeeCool_Client_IOS
//
//  Created by Apple on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, WXApiDelegate {
    //    微信支付参数：
    //    注意 ：参数需要你自己提供
    
    var kWXAppID = "wx71ee9539ea8a79ab"
    var kWXAppSecret  = "9d5b7c975a5ac253d622bb7fdb9a714d"
    
    /**
    * 微信开放平台和商户约定的支付密钥
    *
    * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
    */
    var kWXPartnerKey  = "776d18cee51fe17745d6a30dba083bcd"
    
    /**
    * 微信开放平台和商户约定的支付密钥
    *
    * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
    */
    var kWXAppKey = "QaBb4Zy1lrSQTEZ5zGufAC9QCtvIM1YKVPbG7mumaqj0sV7OHUfiGNeM8mX5923mZfeyClAuXgi7Ly4vDt9JvnTTXxzTyVq5eK4Ae0hM71dTzjS8fz934NaYeOyGEjjh"
    
    /**
    *  微信公众平台商户模块生成的ID
    */
    var kWXPartnerId = "1221631701"
    var appkey = "4682729a0788"
    var appsecret = "14e6b542fb4780ec57c1ca6544c6a303"
    var window: UIWindow?
    var locationMananger = CLLocationManager()
    var latitude = CLLocationDegrees()
    var longtitude = CLLocationDegrees()
    var detailLocation =  NSString()
    func updateLocation(locationManager: CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.delegate = self
        if UIDevice.currentDevice().systemVersion >= "8.0" {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var loc = locations.last as CLLocation
        var coord = loc.coordinate
        latitude = coord.latitude
        longtitude = coord.longitude
        var geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
            if placemarks != nil {
                var arr:NSArray = placemarks as NSArray
                for place in arr {
                    var test:NSDictionary = ((place as CLPlacemark).addressDictionary) as NSDictionary
                    var str = (test["FormattedAddressLines"] as NSArray).firstObject as NSString
                    self.detailLocation = str
                    print(str)
                }
                
            }else {
                print("定位失败")
            }
        })
        manager.stopUpdatingLocation()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var isok = WXApi.registerApp(kWXAppID)
        if isok {
            print("微信注册成功")
        }else {
            print("微信注册失败")
        }
       SMS_SDK.registerApp(appkey, withSecret: appsecret)
       updateLocation(locationMananger)
        ShareSDK.registerApp(appkey)
        ShareSDK.connectSinaWeiboWithAppKey("585583252", appSecret: "99347fc7fb789eff3243655dd4b539b5", redirectUri: "http://www.lanou3g.com")
        var weibosdk = ShareSDK()
        ShareSDK.connectSinaWeiboWithAppKey("585583252", appSecret: "99347fc7fb789eff3243655dd4b539b5", redirectUri: "http://www.lanou3g.com", weiboSDKCls: weibosdk.classForCoder)
        ShareSDK.connectWeChatWithAppId("wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249", wechatCls: WXApi.self)
        var userdefault = NSUserDefaults.standardUserDefaults()
        if userdefault.objectForKey("userLog") == nil {
            userdefault.setObject("", forKey: "userLog")
        }
        var historyArr = [] as NSMutableArray
        if userdefault.objectForKey("historyLocation") == nil {
            userdefault.setObject(historyArr, forKey: "historyLocation")
        }
//        print(NSTemporaryDirectory())
     
        
        
        
        return true
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return ShareSDK.handleOpenURL(url, wxDelegate: self)
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if sourceApplication == "com.tencent.xin" {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: {(result) -> Void in
                print(result as NSDictionary)
            })
            return true
        }
        return ShareSDK.handleOpenURL(url, sourceApplication: sourceApplication, annotation: annotation, wxDelegate: self)
    }
    func onResp(resp: BaseResp!) {
        print(resp)
        print("*******")
        if resp.isKindOfClass(PayResp.classForCoder()) {
            var strTitle = "支付结果"
            var strmessage = NSString(format:"errcode:%d", resp.errCode)
            var alert = UIAlertView(title: strTitle, message: strmessage, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

