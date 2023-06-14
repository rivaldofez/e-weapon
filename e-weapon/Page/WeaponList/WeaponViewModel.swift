//
//  WeaponViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 14/06/23.
//

import UIKit


class WeaponViewModel: ObservableObject {
    
    private let databaseManager = DatabaseManager.shared
    
    @Published var weapon: [WeaponEntity] = []
    
    init() {
        fetchWeapon()
    }
    
    
    func fetchWeapon(){
        self.weapon = databaseManager.fetchWeapon()
    }
    
}
