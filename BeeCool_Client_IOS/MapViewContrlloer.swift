//
//  MapViewContrlloer.swift
//  BeeCool_Client_IOS
//
//  Created by caiyang on 14/12/11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
protocol sendbackLocation {
    func sendbackloc(str:NSString, str1:NSString)
  
}

class MapViewContrlloer: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextViewDelegate, UITextFieldDelegate{
    var delegate = sendbackLocation?()
    var latitude = CLLocationDegrees()
    var longtitude = CLLocationDegrees()
    var cellString = NSString()
    var locationMananger = CLLocationManager()
    
    var selectedFlag = -1
    var userDefault = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func satelliteButonOnclick(sender: UIButton) {
        if mapView.mapType == MKMapType.Standard {
            mapView.mapType = MKMapType.Hybrid
            sender.setTitle("标准", forState: UIControlState.Normal)
        }else {
            mapView.mapType = MKMapType.Standard
            sender.setTitle("卫星", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func locateButtonOnClick(sender: UIButton) {
         updateLocation(locationMananger)
        selectedFlag = -1
        var center =  CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        var span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        var region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func finishedOnclick(sender: UIBarButtonItem) {
        if selectedFlag == -1 {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
            var textview = cell?.contentView.viewWithTag(101) as UITextView
            var textField = cell?.contentView.viewWithTag(102) as UITextField
            var lati = mapView.centerCoordinate.latitude
            var lonti = mapView.centerCoordinate.longitude
            var historydic = NSDictionary(objectsAndKeys:textview.text,"name",textField.text,"detail", lati,"lati", lonti,"lonti")
            var historyarr = userDefault.objectForKey("historyLocation") as NSArray
            var newarr:NSMutableArray = NSMutableArray(array: historyarr)
            newarr.insertObject(historydic, atIndex: 0)
            userDefault.setObject(newarr, forKey: "historyLocation")
            
            self.delegate?.sendbackloc(textview.text, str1: textField.text)
        }else {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedFlag, inSection: 1)) as UITableViewCell?
            var str = cell?.textLabel.text
            var str1 = cell?.detailTextLabel?.text
            self.delegate?.sendbackloc(str!, str1: str1!)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            tableView.contentOffset.y = -64
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tableView.contentOffset.y = -64
        return true
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 60
        }
        return 100
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        return "历史位置"
    }
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
                   self.cellString = str.substringFromIndex(2)
                   self.tableView.reloadData()
                    print(self.cellString)
                }
            }else {
                print("定位失败")
            }
        })
        manager.stopUpdatingLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
    
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        var app = UIApplication.sharedApplication().delegate as AppDelegate
        latitude = app.latitude
        longtitude = app.longtitude
        self.cellString = app.detailLocation
        self.tableView.reloadData()
        var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        var textview = cell?.contentView.viewWithTag(101) as UITextView
        var textField = cell?.contentView.viewWithTag(102) as UITextField
        textview.delegate = self
        textview.text = cellString
        textField.delegate = self
        textField.text = ""
        var center =  CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        var span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        var region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)

    }
    func handleKeyboardDidShow(notification:NSNotification) {
        var dictionary = notification.userInfo as NSDictionary!
        var kbsize = dictionary.objectForKey(UIKeyboardFrameEndUserInfoKey)!.CGRectValue().size
        tableView.contentOffset.y = kbsize.height / 2
    }
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        selectedFlag = -1
        var region:MKCoordinateRegion?
        var centerCoordinate = mapView.region.center
        region?.center = centerCoordinate
        var location = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        var geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if placemarks != nil {
                var arr:NSArray = placemarks as NSArray
                for place in arr {
                    var test:NSDictionary = ((place as CLPlacemark).addressDictionary) as NSDictionary
                    var str = (test["FormattedAddressLines"] as NSArray).firstObject as NSString
                    self.cellString = str.substringFromIndex(2)
                    print(str)
                    var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
                    var textview = cell?.contentView.viewWithTag(101) as UITextView
                    textview.text = self.cellString
                    self.tableView.reloadData()
                }
                
            }
        })
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if userDefault.objectForKey("historyLocation") == nil {
                return 0
            }else{
                if userDefault.objectForKey("historyLocation")?.count > 5 {
                    return 5
                }
                return userDefault.objectForKey("historyLocation")!.count
                
            }
            
    }
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        var cell = tableView.dequeueReusableCellWithIdentifier("mapdetailCell", forIndexPath: indexPath) as UITableViewCell
        return cell
        }
        var cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as UITableViewCell
        var arr = userDefault.objectForKey("historyLocation") as NSMutableArray
        if arr.count > 0 {
        cell.textLabel.font = UIFont.boldSystemFontOfSize(14)
        cell.textLabel.text = (arr.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("name") as NSString
        cell.detailTextLabel?.text = (arr.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("detail") as? NSString
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
           selectedFlag = indexPath.row
            var arr = userDefault.objectForKey("historyLocation") as NSMutableArray
            if arr.count > 0 {
            var center =  CLLocationCoordinate2D(latitude: (arr.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("lati") as Double, longitude: (arr.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("lonti") as Double)
            var span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            var region = MKCoordinateRegionMake(center, span)
            mapView.setRegion(region, animated: true)
            }
        }
    }
 
}
