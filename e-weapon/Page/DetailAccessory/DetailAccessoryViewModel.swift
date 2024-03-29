//
//  DetailAccessoryViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 17/06/23.
//

import UIKit

class DetailAccessoryViewModel: ObservableObject {
    
    private let databaseManager = DatabaseManager.shared
    
    func updateAccessory(id: String, name: String, addedAt: Date, price: Double, stock: Int, location: String, status: String, imageUrl: String, image: UIImage , completion: @escaping (Result<Void, Error>) -> Void){
        
        databaseManager.updateAccessory(id: id, name: name, addedAt: addedAt, price: price, stock: stock, location: location, status: status, imageUrl: imageUrl, image: image, completion: completion)
    }
    
}

