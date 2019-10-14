//
//  CellTableViewController.swift
//  24 - MapView
//
//  Created by Lorem on 3/8/19.
//  Copyright © 2019 Bontar. All rights reserved.
//

import UIKit
import MapKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var streetNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    // MARK: func to show mapView annotation in cell in zoom
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
            
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            self.mapView.setRegion(region, animated: false)
            
            
        }
    }
}
