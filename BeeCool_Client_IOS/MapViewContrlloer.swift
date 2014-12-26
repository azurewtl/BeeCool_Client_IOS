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
    
    @IBOutlet var textField: UITextField!
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
        var center =  CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        var span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        var region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
    }

    @IBAction func finishOnclick(sender: UIButton) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        var textview = cell?.contentView.viewWithTag(101) as UITextView
        self.delegate?.sendbackloc(textview.text, str1: textField.text)
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
        return 50
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
                   self.cellString = str
                   self.tableView.reloadData()
                    print(str)
                }
            }else {
                print("定位失败")
            }
        })
        manager.stopUpdatingLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.text = ""
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
        textview.delegate = self
        textview.text = cellString
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
                    self.cellString = str
                    print(str)
                    var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
                    var textview = cell?.contentView.viewWithTag(101) as UITextView
                    textview.text = self.cellString
                    self.tableView.reloadData()
                }
                
            }
        })

       
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mapdetailCell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }
 
}
