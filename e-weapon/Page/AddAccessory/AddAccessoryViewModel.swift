//
//  AddAccessoryViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 17/06/23.
//

import UIKit


class AddAccessoryViewModel: ObservableObject {
    
    private let databaseManager = DatabaseManager.shared
    
    func addAccessory(id: String, name: String, addedAt: Date, price: Double, stock: Int, location: String, status: String, image: UIImage , completion: @escaping (Result<Void, Error>) -> Void){
        
        databaseManager.addAccessory(id: id, name: name, addedAt: addedAt, price: price, stock: stock, location: location, status: status, image: image, completion: completion)
    }
    
}
