//
//  UserDefaults.swift
//  24 - MapView
//
//  Created by Lorem on 14.10.2019.
//  Copyright © 2019 Bontar. All rights reserved.
//

import Foundation

/*
 // MARK: - save to Userdefaults
extension MapViewController {
 
    private func savePlacesToUserDefaults() {
        let encodeData = try? NSKeyedArchiver.archivedData(withRootObject: myPlacesArray, requiringSecureCoding: false)
        
        UserDefaults.standard.set(encodeData, forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }
    
    private func getAllSavedTasksFromUserDefaults() {
        guard let decodedData = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data else { return }
        
        let decodedTasks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedData)
        if let places = decodedTasks as? [MyPlace] {
            myPlacesArray = places
        }
    }
}
*/
