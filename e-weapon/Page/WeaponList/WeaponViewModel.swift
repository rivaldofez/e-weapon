//
//  WeaponViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 14/06/23.
//

import UIKit


class WeaponViewModel: ObservableObject {
    
    private let databaseManager = DatabaseManager.shared
    
    @Published var weapon: [Weapon] = []
    
    func fetchWeapon(){
        print("before")
        print(weapon)
        
        self.weapon.removeAll()
        self.weapon = databaseManager.fetchWeapon()
            .map {
                return Weapon(id: $0.id, name: $0.name, addedAt: $0.addedAt, price: $0.price, stock: $0.stock, imageUrl: $0.imageUrl, location: $0.location, status: $0.status)
            }
        
        print("after")
        print(weapon)
    }
    
    func deleteWeapon(id: String, completion: @escaping (Result<Void, Error>) -> Void){
        self.weapon.removeAll { $0.id == id}
        print(weapon)
        print(weapon.count)
        
        databaseManager.deleteWeapon(id: id, completion: completion)
    }
    
}
