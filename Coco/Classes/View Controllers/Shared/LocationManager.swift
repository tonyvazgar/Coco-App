//
//  LocationManager.swift
//  Coco
//
//  Created by Carlos Banos on 1/11/21.
//  Copyright © 2021 Easycode. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    typealias LocationCompletionBlock = (Swift.Result<Bool, Error>) -> ()
    
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    private var coordinate: CLLocationCoordinate2D?
    private var completionBlock: (LocationCompletionBlock)?
    
    var latitude: String {
        coordinate?.latitude.description ?? "0.0"
    }
    
    var longitude: String {
        coordinate?.longitude.description ?? "0.0"
    }
    
    func requestLocation(completion: @escaping(LocationCompletionBlock)) {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            completion(.failure(LocationError.denied))
            return
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            completion(.failure(LocationError.unknown))
            return
        }
        completionBlock = completion
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted, .notDetermined:
            completionBlock?(.failure(LocationError.denied))
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        @unknown default:
            completionBlock?(.failure(LocationError.unknown))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinate = locations.last?.coordinate
        locationManager.stopUpdatingLocation()
        completionBlock?(.success(true))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completionBlock?(.failure(error))
    }
}

enum LocationError: Error {
    case denied
    case unknown
    
    var localizedDescription: String {
        "Location not authorize"
    }
}
