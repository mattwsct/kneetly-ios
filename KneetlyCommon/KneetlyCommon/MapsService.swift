//
//  MapsService.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 13/01/2017.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import GoogleMaps
import GoogleMapsDirections
import GooglePlaces

public class MapsService {
    
    public static let shared = MapsService()
    
    public func configure() {
        GMSServices.provideAPIKey(AppConfig.GoogleMaps.apiKey)
        GoogleMapsDirections.provide(apiKey: AppConfig.GoogleMaps.apiKey)
        GMSPlacesClient.provideAPIKey(AppConfig.GoogleMaps.apiKey)
    }
    
    private init() {
    }

    public func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (_ address: String?) -> ()) {
        GMSGeocoder().reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let address = response?.firstResult(), let thoroughfare = address.thoroughfare {
                completion(thoroughfare)
            }
            else {
                completion(nil)
            }
        }
    }
    
    public func calculateTravelTime(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping (_ time: String?, _ destinationAddress: String?) -> ()) {
        let origin = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsDirections.LocationCoordinate2D(latitude: from.latitude, longitude: from.longitude))
        let destination = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsDirections.LocationCoordinate2D(latitude: to.latitude, longitude: to.longitude))
        
        GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination) { (response, error) -> Void in
            // Check Status Code
            guard response?.status == GoogleMapsDirections.StatusCode.ok else {
                completion(nil, nil)
                return
            }
            
            // Use .result or .geocodedWaypoints to access response details
            // response will have same structure as what Google Maps Directions API returns
            if let leg = response?.routes.first?.legs.first {
                completion(leg.duration?.text, leg.endAddress)
            }
            else {
                completion(nil, nil)
            }
        }
    }
}
