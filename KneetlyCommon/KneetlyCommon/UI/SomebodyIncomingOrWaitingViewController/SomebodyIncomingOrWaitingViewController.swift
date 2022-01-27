//
//  SomebodyIncomingOrWaitingViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 03.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import ActiveLabel
import HCSStarRatingView
import AlamofireImage
import CoreLocation
import MapKit

public enum IncomingOrWaitingTargetType: String {
    case none = ""
    case user = "users"
    case washer = "washer"
}

open class SomebodyIncomingOrWaitingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: ActiveLabel!
    @IBOutlet weak var targetAvatarImageView: UIImageView!
    @IBOutlet weak var targetDataLabel: ActiveLabel!
    @IBOutlet weak var targetRatingView: HCSStarRatingView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    open private(set) var targetType: IncomingOrWaitingTargetType = .none
    open private(set) var bookingId: String!
    open private(set) var targetId: String!
    open private(set) var bookingDataSource: DataSource<BookingWash>!
    open private(set) var targetDataSource: DataSource<User>!
    open private(set) var targetLocationDataSource: DataSource<Location>!
    
    fileprivate lazy var locationManager: CLLocationManager? = {
        if (CLLocationManager.locationServicesEnabled()) {
            let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.distanceFilter = 10.0
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            return locationManager
        }
        return nil
    }()
    
    fileprivate var timer: Timer!
    
    fileprivate var myLocation: CLLocationCoordinate2D! {
        didSet {
            updatePins()
        }
    }
    
    // MARK: - Configuration
    
    public func configure(
        targetType: IncomingOrWaitingTargetType,
        bookingId: String,
        targetId: String,
        bookingDataSource: DataSource<BookingWash>,
        targetDataSource: DataSource<User>,
        targetLocationDataSource: DataSource<Location>) {
        self.targetType = targetType
        self.bookingId = bookingId
        self.targetId = targetId
        self.bookingDataSource = bookingDataSource
        self.targetDataSource = targetDataSource
        self.targetLocationDataSource = targetLocationDataSource
    }
    
    // MARK: - 
    
    open func didReloadBooking(_ booking: BookingWash?) {
        self.updateBookingUI(booking)
    }
    
    // MARK: - View controller lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        bookingDataSource.reload() { [unowned self] in
            self.didReloadBooking(self.bookingDataSource.object)
        }
        targetDataSource.reload() { [unowned self] in
            self.updateTargetUI()
        }
        targetLocationDataSource.reload() { [unowned self] in
            self.updatePins()
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager?.startUpdatingLocation()
        timer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(updateLocations),
            userInfo: nil,
            repeats: true
        )
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Actions
    
    func updateLocations() {
        updateMyLocation()
        targetLocationDataSource.reload() {
            self.updatePins()
        }
    }
    
    // MARK: - Helpers
    
    private func updatePins() {
        mapView.removeAnnotations(mapView.annotations)
        
        var userAnnotation: UserAnnotation?
        switch targetType {
        case .user:
            if let myLocation = self.myLocation {
                userAnnotation = UserAnnotation()
                userAnnotation!.coordinate = myLocation
            }
        case .washer:
            if let targetLocation = targetLocationDataSource.object {
                userAnnotation = UserAnnotation()
                userAnnotation!.coordinate = CLLocationCoordinate2DMake(targetLocation.latitude, targetLocation.longitude)
            }
        default: break
        }
        
        var washerAnnotation: WasherAnnotation?
        switch targetType {
        case .user:
            if let targetLocation = targetLocationDataSource.object {
                washerAnnotation = WasherAnnotation()
                washerAnnotation!.coordinate = CLLocationCoordinate2DMake(targetLocation.latitude, targetLocation.longitude)
            }
        case .washer:
            if let myLocation = self.myLocation {
                washerAnnotation = WasherAnnotation()
                washerAnnotation!.coordinate = myLocation
            }
        default: break
        }
        
        var annotations:[CustomImageAnnotation] = []
        if (userAnnotation != nil) {
            annotations.append(userAnnotation!)
        }
        if (washerAnnotation != nil) {
            annotations.append(washerAnnotation!)
        }
        
        mapView.addAnnotations(annotations)
        
        mapView.showAnnotations(annotations, animated: true)
    }
    
    private func updateBookingUI(_ booking: BookingWash?) {
        if let booking = booking {
            var titleString = ""
            var statusString = ""
            
            switch targetType {
            case .user:
                titleString = booking.isWasherComing! ? R.string.localized.washerIncomingWasherOnTheirWayLabelText() : R.string.localized.washerWaitingWasherReadyLabelText()
                statusString = booking.isWasherComing! ? R.string.localized.washerIncomingWasherIsDrivingLabelText() : R.string.localized.washerWaitingWasherAwaitingLabelText()
                addressLabel.text = booking.isWasherComing! ? nil : booking.address
            case .washer:
                titleString = titleText()
                targetDataLabel.text = "\(booking.washTypeName ?? "")\n\(booking.modelName != nil ? booking.modelName! + " " : "")"
                
                addressLabel.text = booking.isWasherComing! ? booking.address : nil
            default: break
            }
            
            titleLabel.text = titleString
            statusLabel.text = statusString
        }
    }
    
    private func updateTargetUI() {
        if let target = self.targetDataSource.object {
            if let avatarURL = URL(string: target.avatar) {
                targetAvatarImageView.af_setImage(withURL: avatarURL)
            }
            targetRatingView.value = CGFloat(target.rating)
            
            var dataString = ""
            
            switch targetType {
            case .user:
                dataString = "\(target.firstName != nil ? target.firstName! + " " : "")\(target.lastName ?? "")"
                targetDataLabel.text = dataString
            case .washer:
                titleLabel.text = titleText()

            default: break
            }
        }
    }
    
    private func titleText() -> String {
        if let target = self.targetDataSource.object, let firstName = target.firstName, let booking =  self.bookingDataSource.object {
            return booking.isWasherComing! ? R.string.localized.userWaitingTitleLabelFormat(firstName) : R.string.localized.userIncomingTitleLabelFormat(firstName)
        }
        
        return ""
    }
    
    private func updateMyLocation() {
        if (myLocation != nil) {
            let request = ApiEndpoints.LocationRequest.updateMyLocationRequest(
                consumer: targetType.rawValue,
                latitude: myLocation.latitude,
                longitude: myLocation.longitude
            )
            BaseAppDelegate.current().requestSender.sendRequest(apiRequest: request) { _ in }
        }
    }
}

extension SomebodyIncomingOrWaitingViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomImageAnnotation else {
            return nil
        }
        let reuseIdentifier = "CustomImageAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = annotation.image
        
        return annotationView
    }
}

extension SomebodyIncomingOrWaitingViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            myLocation = location.coordinate
        }
    }
}
