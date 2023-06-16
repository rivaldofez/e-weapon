//
//  DetailWeaponViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 15/06/23.
//

import UIKit


class DetailWeaponViewModel: ObservableObject {
    
    private let databaseManager = DatabaseManager.shared
    
    func updateWeapon(id: String, name: String, addedAt: Date, price: Double, stock: Int, location: String, status: String, imageUrl: String, image: UIImage , completion: @escaping (Result<Void, Error>) -> Void){
        
        databaseManager.updateWeapon(id: id, name: name, addedAt: addedAt, price: price, stock: stock, location: location, status: status, imageUrl: imageUrl, image: image, completion: completion)
    }
    
}
