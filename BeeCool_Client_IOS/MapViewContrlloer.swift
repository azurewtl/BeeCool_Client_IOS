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
class MapViewContrlloer: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource{
    var latitude = CLLocationDegrees()
    var longtitude = CLLocationDegrees()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
//            print(app.detailLocation)
        }
        dispatch_group_notify(group, queue) { () -> Void in
            self.mapView.addAnnotation(ano)
        }
        var center =  CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        var span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        var region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)

    }
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        var region:MKCoordinateRegion?
        var centerCoordinate = mapView.region.center
        region?.center = centerCoordinate
        print(centerCoordinate.latitude)
        print(centerCoordinate.longitude)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mapdetailCell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }
 
}
