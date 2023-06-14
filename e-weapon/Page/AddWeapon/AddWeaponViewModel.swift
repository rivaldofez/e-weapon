//
//  AddWeaponViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 14/06/23.
//

import Foundation


class AddWeaponViewModel: ObservableObject {
    
    private let databaseManager = DatabaseManager.shared
    
    func addWeapon(id: String, name: String, addedAt: Date, price: Double, stock: Int, imageUrl: String, location: String, status: String, completion: @escaping (Result<Void, Error>) -> Void){
        
        databaseManager.addWeapon(id: id, name: name, addedAt: addedAt, price: price, stock: stock, imageUrl: imageUrl, location: location, status: status, completion: completion)
    }
}
