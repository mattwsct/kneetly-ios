//
//  LocationSelectionViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 26/12/2016.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

public protocol LocationSelectionDelegate: class {
    func didSelectLocation(_ location: AddressedLocation?)
}

public protocol WasherSelectionDelegate: class {
    func didSelectWasher(_ id: String?)
}

public protocol WashLocationSelectionDataSource: class {
    func carName() -> String?
    func isWasherComing() -> Bool
}

open class LocationSelectionViewController: UIViewController {
    
    open weak var delegate: LocationSelectionDelegate?
    
    open weak var washerSelectionDelegate: WasherSelectionDelegate?
    
    open weak var dataSource: WashLocationSelectionDataSource?
    
    open var mapRadius: Double? {
        didSet {
            zoomMap(to: mapRadius)
        }
    }
    
    @IBOutlet open weak var titleLabel: UILabel!
    
    @IBOutlet open weak var mapView: MKMapView!
    
    @IBOutlet open weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!

    fileprivate var locationManager: CLLocationManager?
    
    open var location: AddressedLocation?
    
    // MARK: Life cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        configureAndStartLocationManagerIfEnabled()
        configureMapGestureRecognizer()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLocationManager()
    }
    
    deinit {
        stopLocationManager()
    }
    
    open func updateLocationInfo(withAddress address: String?) {
        addressLabel.text = address
    }
    
    open func updateLocationInfo(withCoordinate coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else {
            addressLabel.text = ""
            return
        }
        
        MapsService.shared.reverseGeocode(coordinate: coordinate) { [unowned self] (address: String?) in
            self.addressLabel.text = address
        }
    }
}

extension LocationSelectionViewController: MKMapViewDelegate, UIGestureRecognizerDelegate {
    func configureMapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureReconizer:)))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleTap(gestureReconizer: UITapGestureRecognizer) {
        let hittedView = mapView.hitTest(gestureReconizer.location(in: mapView), with: nil)
        if let _ = hittedView as? MKAnnotationView {
            return
        }
        
        stopLocationManager()
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        self.location = AddressedLocation(coordinate: coordinate)
    }
    
    open func annotations() -> [MKAnnotation] {
        guard let coordinate = location?.coordinate else {
            return []
        }
        
        let annotation = UserAnnotation()
        annotation.coordinate = coordinate
        
        return [annotation]
    }
    
    open func updatePins(animated: Bool = true) {
        guard let coordinate = location?.coordinate else {
            return
        }
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = UserAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotations(annotations())
        
        if animated {
            mapView.showAnnotations(annotations(), animated: true)
        }
    }
    
    public func zoomMap(to radius: Double?) {
        guard let radius = radius, let coordinate = location?.coordinate else {
            return
        }
        
        let distanceInMeters = radius * 2 * 1000
        
        let region = MKCoordinateRegionMakeWithDistance(coordinate, distanceInMeters, distanceInMeters)
        
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: MKMapViewDelegate
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomImageAnnotation else {
            return nil
        }
        
        let reuseIdentifier = "CustomImageAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = annotation.image
        
        return annotationView
    }
}

extension LocationSelectionViewController: CLLocationManagerDelegate {
    func configureAndStartLocationManagerIfEnabled() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.distanceFilter = 10.0
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
        }
    }
    
    func stopLocationManager() {
        locationManager?.stopUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = AddressedLocation(coordinate: location.coordinate)
        }
    }
}

extension LocationSelectionViewController: UISearchBarDelegate {
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Set a filter to return only addresses.
        let addressFilter = GMSAutocompleteFilter()
        addressFilter.country = "AU"
        autocompleteController.autocompleteFilter = addressFilter
        
        present(autocompleteController, animated: true, completion: nil)
        
        return false
    }
}

extension LocationSelectionViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        stopLocationManager()
        
        location = AddressedLocation(coordinate: place.coordinate, address: place.name)
        mapRadius = 2
        // Close the autocomplete widget.
        self.dismiss(animated: true, completion: nil)
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    public func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    public func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
