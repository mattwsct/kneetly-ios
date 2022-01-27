//
//  WasherLocationSelectionViewController.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 01/02/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import MapKit
import KneetlyCommon

class WasherLocationSelectionViewController: LocationSelectionViewController {
    
    override var location: AddressedLocation? {
        didSet {
            updatePins(animated: false)
            requestWashersNear(location?.coordinate, radius: mapRadius)
        }
    }
    
    private var washerAnnotation: WasherAnnotation? {
        didSet {
            washerSelectionDelegate?.didSelectWasher(washerAnnotation?.washer.id)
            delegate?.didSelectLocation(AddressedLocation(coordinate: washerAnnotation!.coordinate))
            
            updateTravelTimeInfo(fromCoordinate: location?.coordinate, toCoordinate: washerAnnotation?.coordinate)
            updateLocationInfo(withCoordinate: washerAnnotation?.coordinate)
        }
    }
    
    private var washersAnnotations: [MKAnnotation]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = R.string.localized.confirmBookingWhereDoYouWantToGetYourCarWashedFormat(dataSource?.carName() ?? R.string.localized.confirmBookingDefaultCarName())
    }
    
    private func currentMapRadius() -> Double? {
        guard mapRadius != nil else {
            return nil
        }
        
        let mRect: MKMapRect = mapView.visibleMapRect
        let topMapPoint = MKMapPointMake(MKMapRectGetMidX(mRect), MKMapRectGetMinY(mRect))
        let bottomMapPoint = MKMapPointMake(MKMapRectGetMidX(mRect), MKMapRectGetMaxY(mRect))
        let currentDistWideInMeters = MKMetersBetweenMapPoints(topMapPoint, bottomMapPoint)
        
        return (currentDistWideInMeters / 2.0) / 1000.0
    }
    
    private func requestWashersNear(_ coordinate: CLLocationCoordinate2D?, radius: Double?) {
        
        guard let coordinate = coordinate else {
            return
        }
        
        let request = ApiEndpoints.Washer.nearbyWashersRequest(latitude: coordinate.latitude, longitude: coordinate.longitude, radius: currentMapRadius())
        
        AppDelegate.current().requestSender.sendRequest(apiRequest: request) { (result) in
            switch result {
            case .success(let nearbyWashersList):
                var array = [WasherAnnotation]()
                
                for washer in nearbyWashersList.washers {
                    let annotation = WasherAnnotation(withWasher: washer)
                    let coordinate = CLLocationCoordinate2D(latitude: washer.location!.latitude, longitude: washer.location!.longitude)
                    annotation.coordinate = coordinate
                    array.append(annotation)
                }
                
                array.first?.isSelected = true
                self.washerAnnotation = array.first
                self.washersAnnotations = array
                self.mapRadius = nearbyWashersList.radius
            case .failure( _): break
                // TODO: Handle
            }
            
            self.updatePins(animated: false)
        }
    }
    
    fileprivate func updateTravelTimeInfo(fromCoordinate from: CLLocationCoordinate2D?, toCoordinate to: CLLocationCoordinate2D?) {
        guard let from = from, let to = to else {
            updateTravelTimeLabelWithInfo(nil)
            return
        }
        
        MapsService.shared.calculateTravelTime(from: from, to: to) { [unowned self] (time: String?, destinationAddress: String?) in
            self.updateTravelTimeLabelWithInfo(time)
        }
    }
    
    fileprivate func updateTravelTimeLabelWithInfo(_ info: String?) {
        guard let washerAnnotation = washerAnnotation else {
            subtitleLabel.text = ""
            return
        }
        
        var text = ""
        text = R.string.localized.confirmBookingWasherRatingFormat("\(washerAnnotation.washer.rating)")
        if let info = info {
            text += R.string.localized.confirmBookingWasherTimeDriveFormat(info)
        }
        
        subtitleLabel.text = text
    }

    override func annotations() -> [MKAnnotation] {
        return super.annotations() + (washersAnnotations ?? [])
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? WasherAnnotation, !selectedAnnotation.isSelected else {
            return
        }
        
        for annotation in mapView.annotations {
            (annotation as? CustomImageAnnotation)?.isSelected = false
        }
        
        selectedAnnotation.isSelected = true
        washerAnnotation = view.annotation as! WasherAnnotation!
        
        updatePins(animated: false)
    }
}
