//
//  MapViewPinDetail.swift
//  24 - MapView
//
//  Created by Lorem on 3/7/19.
//  Copyright © 2019 Bontar. All rights reserved.
//

import UIKit


protocol DeletePlaceDelegate {
    func didDeletePlace(placeToDelete: MyPlace)
}


class MapViewPinDetail: UIViewController {
    

    // MARK:- Properties
    
    var detailMyPlaceArray : [MyPlace] = []
    var delegete : DeletePlaceDelegate?
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
}



//MARK: - TableViewDelegate, TableViewDataSource

extension MapViewPinDetail: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailMyPlaceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlaceTableViewCell {
            
            let annotationElement = detailMyPlaceArray[indexPath.row]
            
            //name
            let streetName = annotationElement.title
            // country
            let country = annotationElement.country
            //postal code
            let postalCode = annotationElement.postalCode
            
            //coordinates
            let latitude = annotationElement.coordinate.latitude
            let longitude = annotationElement.coordinate.longitude
            let stringLatitude = String(format:"%f", latitude)
            let stringLongitude = String(format:"%f", longitude)
            
            //adding to cell label
            cell.streetNameLabel.text = streetName
            cell.countryLabel.text = country
            cell.postalCodeLabel.text = postalCode
            cell.coordinatesLabel.text = "\(stringLatitude)\n \(stringLongitude)"
            
            cell.configureLocation(location: streetName ?? "")
            
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 180.0 }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let placeToDelete = detailMyPlaceArray[indexPath.row]
            
            // delegate function
            deletePlace(placeToDelete)
            
            detailMyPlaceArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }

    // MARK: - Delegate
    func deletePlace(_ place: MyPlace?) {
        if let placeToDelete = place {
            delegete?.didDeletePlace(placeToDelete: placeToDelete)
        }
    }
}
