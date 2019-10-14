//
//  Annotation.swift
//  24 - MapView
//
//  Created by Lorem on 3/9/19.
//  Copyright © 2019 Bontar. All rights reserved.
//

import Foundation
import MapKit

class MyPlace: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let country: String?
    let postalCode: String?
    
    
    init(title: String, coordinate: CLLocationCoordinate2D, country: String, postalCode: String) {
        
        self.title = title
        self.coordinate = coordinate
        self.country = country
        self.postalCode = postalCode
        
    }
}


