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
class MapViewContrlloer: UIViewController, MKMapViewDelegate{

    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var ano = myAnnotation()
        mapView.delegate = self
        mapView.addAnnotation(ano)
     var center =  CLLocationCoordinate2D(latitude: 40.029915, longitude: 116.347082)
     var span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
     var region = MKCoordinateRegion(center: center, span: span)
     mapView.setRegion(region, animated: true)
    }
 
}
