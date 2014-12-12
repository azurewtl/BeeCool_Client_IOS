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
    var latitude = CLLocationDegrees()
    var longtitude = CLLocationDegrees()
    var cellString = NSString()
    
    @IBAction func satelliteButoon(sender: UIButton) {
        if mapView.mapType == MKMapType.Standard {
            mapView.mapType = MKMapType.Hybrid
            sender.setTitle("标准", forState: UIControlState.Normal)
        }else {
            mapView.mapType = MKMapType.Standard
            sender.setTitle("卫星", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func guideButton(sender: UIButton) {
        
        
    }
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        var app = UIApplication.sharedApplication().delegate as AppDelegate
        latitude = app.latitude
        longtitude = app.longtitude
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        var ano = myAnnotation()
        dispatch_group_async(group, queue) { () -> Void in
            ano.latitude = self.latitude
            ano.longtitude = self.longtitude
            ano.detailposition = app.detailLocation
            self.cellString = app.detailLocation
            self.tableView.reloadData()
//            print(app.detailLocation)
        }
        dispatch_group_notify(group, queue) { () -> Void in
            self.mapView.addAnnotation(ano)
        }
        var center =  CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        var span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        var region = MKCoordinateRegionMakeWithDistance(center, 20, 20)
        mapView.setRegion(region, animated: true)

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
        cell.textLabel.text = "位置"
        cell.detailTextLabel?.text = cellString
        return cell
    }
 
}
