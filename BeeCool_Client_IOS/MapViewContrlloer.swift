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
class MapViewContrlloer: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    var locationMananger = CLLocationManager()
    var latitude = CLLocationDegrees()
    var longtitude = CLLocationDegrees()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
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
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        var ano = myAnnotation()
        dispatch_group_async(group, queue) { () -> Void in
            ano.latitude = self.latitude
            ano.longtitude = self.longtitude
            var geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
                if placemarks != nil {
                    var arr:NSArray = placemarks as NSArray
                    for place in arr {
                        var test:NSDictionary = ((place as CLPlacemark).addressDictionary) as NSDictionary
                        var str = NSString(format: "%@, %@, %@, %@",test.objectForKey("Name") as NSString, test.objectForKey("State") as NSString, test.objectForKey("Street") as NSString) as NSString
                        ano.detailposition = str
                    }
                }
            })
        }
       dispatch_group_notify(group, queue) { () -> Void in
         self.mapView.addAnnotation(ano)
        }
       
        
        var center =  CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        var span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        var region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocation(locationMananger)
        mapView.delegate = self
       
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mapdetailCell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }
 
}
