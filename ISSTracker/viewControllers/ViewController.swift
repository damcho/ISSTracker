//
//  ViewController.swift
//  ISSTracker
//
//  Created by Damian Modernell on 27/09/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import GoogleMaps
import MaterialComponents
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    var mapView:GMSMapView?
    var line:GMSMutablePath?
    var marker:GMSMarker?
    
    let ISSViewModel = ISSTrackerViewModel()
    
    let activityData = ActivityData(message:"Updating position...")
    var activityIndicatorView:NVActivityIndicatorPresenter = NVActivityIndicatorPresenter.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupListeners()
        self.loadSettingsButton()
    }
    
    func setupListeners() {
        activityIndicatorView.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)

        self.ISSViewModel.onFetchPositionSuccess = {[unowned self] (ISSPosition:ISSTrackerPosition?) -> () in
            
            self.activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
            
                self.line?.add(CLLocationCoordinate2D(latitude: ISSPosition!.latitude, longitude: ISSPosition!.longitude))
                
                let  polygon = GMSPolyline(path: self.line)
                polygon.strokeColor = .black
                polygon.strokeWidth = 4
                polygon.map = self.mapView
                
                self.marker?.position = CLLocationCoordinate2D(latitude: ISSPosition!.latitude, longitude: ISSPosition!.longitude)
                self.mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: ISSPosition!.latitude, longitude: ISSPosition!.longitude))
        }
        
        self.ISSViewModel.onFetchPositionError =  {[unowned self] (error:Error) -> () in
            self.activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)

            let alert = UIAlertController(title: "Alert", message: error.localizedDescription ,preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadSettingsButton() {
        
        let floatingButton = MDCFloatingButton()
        floatingButton.backgroundColor = .white
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(floatingButton)
        
        let heightConstraint = NSLayoutConstraint (item: floatingButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
        
        let widthConstraint = NSLayoutConstraint (item: floatingButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
        
        floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        floatingButton.addConstraint(widthConstraint)
        floatingButton.addConstraint(heightConstraint)
        
        
        floatingButton.addTarget(self, action: #selector(settingsButtonTapped(floatingButton:)), for: .touchUpInside)
        let plusImage = UIImage(named: "baseline_settings_black_18dp")
        floatingButton.setImage(plusImage, for: .normal)
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
    
    @objc func settingsButtonTapped(floatingButton:MDCFloatingButton){
        let settingsController = SettingsViewController()
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: settingsController)
        
        settingsController.modalPresentationStyle = .overFullScreen
        present(navBarOnModal, animated: true, completion: nil)
    }
}

