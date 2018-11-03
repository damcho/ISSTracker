//
//  ViewController.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    var trackerConnector:ISSTrackerConnector?
    var gameTimer: Timer?
    var mapView:GMSMapView?
    var line:GMSMutablePath?
    var marker:GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerConnector = ISSTrackerConnector()
        gameTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(updateMap), userInfo: nil, repeats: true)
        
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 44.7991, longitude: 52.2692, zoom: 3.0)

        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView?.camera = camera
        self.line = GMSMutablePath()
        self.marker = GMSMarker()
        self.marker!.map = self.mapView

        self.view = mapView
    }
    
    @objc func updateMap() {
        let completionHandler:(ISSTrackerPosition?, String?) -> () = { (ISSPosition:ISSTrackerPosition?, errorMessage:String?) -> () in
            
            if errorMessage == nil {

                self.line!.add(CLLocationCoordinate2D(latitude: ISSPosition!.latitude, longitude: ISSPosition!.longitud))

                let  polygon = GMSPolyline(path: self.line)
                polygon.strokeColor = .black
                polygon.strokeWidth = 4
                polygon.map = self.mapView

                self.marker!.position = CLLocationCoordinate2D(latitude: ISSPosition!.latitude, longitude: ISSPosition!.longitud)
                self.mapView!.animate(toLocation: CLLocationCoordinate2D(latitude: ISSPosition!.latitude, longitude: ISSPosition!.longitud))
                
            } else {
                print(errorMessage!)
                let alert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        trackerConnector!.getISSPosition(completionHandler: completionHandler)
    }
}

