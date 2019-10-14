//
//  CellDetailViewController.swift
//  24 - MapView
//
//  Created by Lorem on 3/14/19.
//  Copyright © 2019 Bontar. All rights reserved.
//

import UIKit
import MapKit

class CellDetailViewController: UIViewController {

    var place : MyPlace?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var returnButtonLabel: UIButton!
  
    @IBOutlet weak var streetLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpInformation()
        
    }
    
    
    @IBAction func returnActionButton(_ sender: Any) {
       
        // returning to main Viewcontroller
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpInformation() {
        
        if let title = place?.title{
            
            streetLabel.text = place?.title
            configureLocation(location: title)
            returnButtonLabel.layer.cornerRadius = 25
          
            
        }
    }
    
    func configureLocation( location: String) {
        
        let geoCoder: CLGeocoder = CLGeocoder()
        
        print(location)
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            guard let placemark = placemarks?.first else {
                
                return
            }
            
            let annotation = MKPointAnnotation()
            
            guard let location = placemark.location else { return }
            annotation.coordinate = location.coordinate
            self.mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
            self.mapView.setRegion(region, animated: false)
            
        }
    }
}
