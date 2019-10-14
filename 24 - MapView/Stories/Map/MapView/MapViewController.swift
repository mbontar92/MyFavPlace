//
//  ViewController.swift
//  24 - MapView
//
//  Created by Lorem on 3/4/19.
//  Copyright © 2019 Bontar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var pinImage: UIImageView!
    
    @IBOutlet weak var pinActionButtonLabel: CustomButton!
    @IBOutlet weak var detailsActionButtonLabel: CustomButton!
    @IBOutlet weak var savePinActionButtonLabel: CustomButton!
    @IBOutlet weak var removeAnnotationActionLabel: CustomButton!
    
    // location
    private var locationManager: CLLocationManager!
    let regionInMeters :Double = 2000
    var lastLocation: CLLocation?
    
    
    // MARK: - properties
    
    var myPlace: MyPlace?
    var myPlacesArray: [MyPlace] = []
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationServises()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - Buttons configure
    
    @IBAction func pinActionButton(_ sender: Any) { pinImage.isHidden = !pinImage.isHidden }
    
    @IBAction func detailsActionButton(_ sender: Any) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewPinDetail") as? MapViewPinDetail {
            
            vc.detailMyPlaceArray = myPlacesArray
            vc.delegete = self
            show(vc, sender: nil)
        }
    }
    
    @IBAction func savePinActionButton(_ sender: Any) { addAnnotation() }
    
    @IBAction func removeAnnotationAction(_ sender: Any) {
        // remove from array
        myPlacesArray.removeAll()
        // remove from mapview
        mapView.removeAnnotations(mapView.annotations)
    }
    
    // colation configure
    func setupLocationServises() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        }
    }

    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse, .authorizedAlways: // when app is open
            startTrackingUserLocation()
            
        case .notDetermined:
            // if it's not determined we ask permission
            locationManager.requestWhenInUseAuthorization()

        case .denied:
            break
        case .restricted:
            // allert letting know whats up
            break
        }
    }
    
    func startTrackingUserLocation () {
        locationManager.startUpdatingLocation()
        if let userCoordinate = locationManager.location?.coordinate {
            centerViewOnLocation(userCoordinate)
        }
    }
    
    //        // MARK - centerViewOnUserLocation
    func centerViewOnLocation(_ location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    // get Center Location
    func getCenterLocation(for: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

 // MARK: - add annotation

extension MapViewController {

    func addAnnotation () {
        
        let currentAnnotation = MKPointAnnotation()

        let geoCoder: CLGeocoder = CLGeocoder()
        // set up annotation
        
        currentAnnotation.coordinate = CLLocationCoordinate2D(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude )
        
        // get street name of annotation
        let center: CLLocation = CLLocation(latitude:mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            guard let placemark = placemarks?.first else { return }
            guard let streetName = placemark.name else { return }
            
            currentAnnotation.title = streetName
            
            let country = placemark.country ?? ""
            
            let postalCode = placemark.postalCode ?? ""
            
            // setup my model
            let place = MyPlace(title: streetName, coordinate: currentAnnotation.coordinate, country: country, postalCode: postalCode)
            // adding to array
            self?.myPlacesArray.append(place)
            
            // adding annotation to mapview
            
            self?.mapView.addAnnotation(place)
        }
    }
}

// MARK: - CLLocation Manager Delegate
extension MapViewController: CLLocationManagerDelegate  {
    
    // update locations when moves - center is location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let userLocation = locations.last else { return }
        
        self.lastLocation = locations.last
        
        
        //        let userRegion = MKCoordinateRegion.init(center: userLocation.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        //        mapView.setRegion(userRegion, animated: true)
    }
    
    // change authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
    }
}

// MARK: - MapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    // showing label text of the center view
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let _ = error {
                // TODO: showing information to user
                return
            }
            guard let placemark = placemarks?.first else {
                // TODO: showing allert to user
                return
            }
            // placemart has many properties
            let streetName = placemark.name ?? ""
            
            DispatchQueue.main.async {
                self.adressLabel.text = "\(streetName)"
            }
        }
    }
    
    // show detail label when tapping on annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MyPlace else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
    
            if  let placeName = view.annotation?.title {
                let locationValue: CLLocationCoordinate2D = view.annotation?.coordinate ?? CLLocationCoordinate2D()
                let latitude : String = locationValue.latitude.description
                let longitude: String = locationValue.longitude.description
                
//                 mapView.selectedAnnotations
                
                let allert = UIAlertController(title: placeName ?? "" , message: "latitude : \(latitude) \n longitude : \(longitude)", preferredStyle: .alert)
                allert.addAction(UIAlertAction(title: "thanks", style: .default))
                present(allert, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let selectedCoordinate = view.annotation?.coordinate {
            centerViewOnLocation(selectedCoordinate)
        }
    }
}



// receiving delegate information
extension MapViewController: DeletePlaceDelegate {
    func didDeletePlace(placeToDelete: MyPlace) {
        
        // дістаю індекс який потрібно видалити
        let index = myPlacesArray.firstIndex { $0.title == placeToDelete.title }
        
        if  let indexToDelete = index {
            self.myPlacesArray.remove(at: indexToDelete)
            // видалив
            // тут мають видалитись всі annotation
            mapView.removeAnnotations(mapView.annotations)
            // і потрібно знову пройтись по масиву і добавити антоації які не видалились в масив
            mapView.addAnnotations(myPlacesArray)
        }
    }
}

