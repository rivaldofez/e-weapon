//
//  AddWeaponViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 14/06/23.
//

import UIKit


class AddWeaponViewModel: ObservableObject {
    
    private let databaseManager = DatabaseManager.shared
    
    func addWeapon(id: String, name: String, addedAt: Date, price: Double, stock: Int, location: String, status: String, image: UIImage , completion: @escaping (Result<Void, Error>) -> Void){
        
        databaseManager.addWeapon(id: id, name: name, addedAt: addedAt, price: price, stock: stock, location: location, status: status, image: image, completion: completion)
    }
}
