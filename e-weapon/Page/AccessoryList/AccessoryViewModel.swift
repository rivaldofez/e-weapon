//
//  AccessoryViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 17/06/23.
//

import UIKit

class AccessoryViewModel: ObservableObject {
    
    private let databaseManager = DatabaseManager.shared
    
    @Published var accessories: [Accessory] = []
    
    func fetchAccessory(){
        
        self.accessories = databaseManager.fetchAccessory()
            .map {
                return Accessory(id: $0.id, name: $0.name, addedAt: $0.addedAt, price: $0.price, stock: $0.stock, imageUrl: $0.imageUrl, location: $0.location, status: $0.status)
            }
    }
    
}
