import Foundation
import UIKit
import CoreLocation

class GetCurrentLocation: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var didUpdatedLocation: (() -> ())?
    var suburbName = String()
    
    func getUserCurrentLocation(viewController: UIViewController) {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyReduced
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let placeMark = placemarks?.first else { return }
            if let suburb = placeMark.locality {
                self.suburbName = suburb
                self.didUpdatedLocation?()
            }
        })
    }
}
