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
    
    func filterSearch(query: String){
        if query.isEmpty {
            fetchAccessory()
        } else {
            fetchAccessory()
            self.accessories = self.accessories.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
    
    func deleteAccessory(id: String, completion: @escaping (Result<Void, Error>) -> Void){
        self.accessories.removeAll { $0.id == id}
        databaseManager.deleteAccessory(id: id, completion: completion)
    }
}
