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

class ISSTrackerViewController: UIViewController {
    
    private var mapView:GMSMapView?
    private var lineCoordinates:GMSMutablePath?
    private var marker:GMSMarker?
    private let LOCATION_POINTS_COUNT:UInt = 3
    private var ISSViewModel: ISSTrackerViewModel?
    
    convenience init(viewModel: ISSTrackerViewModel) {
        self.init()
        self.ISSViewModel = viewModel
        GMSServices.provideAPIKey("AIzaSyAVIvISQPshSOtqRHKu7eZ3zrARhXC6bMI")
    }
    
    override func viewDidLoad() {
        self.title = ISSViewModel?.title
        super.viewDidLoad()
        self.setupCallbacks()
        self.loadSettingsButton()
        self.addObservers()
        self.ISSViewModel?.startReceivingPositionUpdates()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.ISSViewModel?.stopReceivingPositionUpdates()
        }
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.resetMap()
            self?.ISSViewModel?.startReceivingPositionUpdates()
        }
    }
    
    func resetMap() {
        self.lineCoordinates?.removeAllCoordinates()
        self.mapView?.clear()
        self.marker?.map = self.mapView
    }
    
    func setupCallbacks() {
        self.ISSViewModel?.onFetchPositionSuccess = {[weak self] (ISSPosition:ISSTrackerPosition) -> () in
                        
            self?.lineCoordinates?.add(CLLocationCoordinate2D(latitude: ISSPosition.coordinate.latitude, longitude: ISSPosition.coordinate.longitude))
            if self?.lineCoordinates?.count() ?? 0 >= self!.LOCATION_POINTS_COUNT {
                self?.lineCoordinates?.removeCoordinate(at: 0)
            }
            let  polygon = GMSPolyline(path: self?.lineCoordinates)
            polygon.strokeColor = .black
            polygon.strokeWidth = 2
            polygon.map = self?.mapView
            
            self?.marker?.position = CLLocationCoordinate2D(latitude: ISSPosition.coordinate.latitude, longitude: ISSPosition.coordinate.longitude)
            self?.mapView?.animate(toLocation: CLLocationCoordinate2D(latitude: ISSPosition.coordinate.latitude, longitude: ISSPosition.coordinate.longitude))
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
        self.lineCoordinates = GMSMutablePath()
        self.marker = GMSMarker()
        self.marker?.map = self.mapView
        self.marker?.iconView = self.loadMarkerImage()
        self.view = mapView
    }
    
    private func loadMarkerImage() -> UIImageView{
        let issImage = UIImage(named: "issImage")!
        let iconImageView = UIImageView(image: issImage)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 0, y: 0, width: 80, height: 50)
        return iconImageView
    }
    
    @objc func settingsButtonTapped(floatingButton:MDCFloatingButton){
        let settingsController = SettingsViewController()
        settingsController.ISStrackerVM = self.ISSViewModel
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: settingsController)
        
        settingsController.modalPresentationStyle = .overFullScreen
        present(navBarOnModal, animated: true, completion: nil)
    }
}

