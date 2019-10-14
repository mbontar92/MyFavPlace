//
//  AddressDetailViewController.swift
//  24 - MapView
//
//  Created by Lorem on 3/7/19.
//  Copyright © 2019 Bontar. All rights reserved.
//

import UIKit


protocol DeletePlaceDelegate {
    func didDeletePlace(placeToDelete: MyPlace)
}


class AddressDetailViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    // MARK: IBOutlets
    
    // button to return to previous controller
    @IBOutlet weak var returnActionButtonLabel: UIButton!
        
    
    
    // MARK: Variables
    var detailMyPlaceArray : [MyPlace] = []
    var placeDelegete : DeletePlaceDelegate?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        returnActionButtonLabel.layer.cornerRadius = 25
    }
    
    // MARK: IBActions
    @IBAction func returnActionButton(_ sender: Any) {
       
        // returning to main Viewcontroller
        self.dismiss(animated: true, completion: nil)
    }

    
    
    
    // MARK : - tableview configure
    // row's in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailMyPlaceArray.count
    }
    
    // cell configure 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellannotation = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceTableViewCell
        
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
        cellannotation.streetNameLabel.text = streetName
        cellannotation.countryLabel.text = country
        cellannotation.postalCodeLabel.text = postalCode
        cellannotation.coordinatesLabel.text = "\(stringLatitude)\n \(stringLongitude)"
        
        cellannotation.configureLocation(location: streetName ?? "")
        
        return cellannotation
    }
    
    //height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    
    
    //deleting
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // deleting confirm
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let placeToDelete = detailMyPlaceArray[indexPath.row]
            // sending to delegate exactly this row
            // функція делегата, який обєкт передати
            deletePlace(placeToDelete)
            //
            detailMyPlaceArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let infoController = storyboard?.instantiateViewController(withIdentifier: "cellDetail") as? CellDetailViewController else { return }
        
        let rowSelected = detailMyPlaceArray[indexPath.row]
        
        infoController.place = rowSelected
        
        present(infoController, animated: true, completion: nil)
        
    }
    
    
    
    // делегат передає MyPlace
    func deletePlace(_ place: MyPlace?) {
        //потім тут отримав цей обєкт ( який видалити ) і передаю далі
        if let placeToDelete = place {
            placeDelegete?.didDeletePlace(placeToDelete: placeToDelete)
            
        }
    }
}
