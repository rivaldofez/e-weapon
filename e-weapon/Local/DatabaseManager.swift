//
//  DatabaseManager.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import Foundation
import RealmSwift


enum DatabaseError: Error {
    case usernameExist
    case failedToFetchData
    case cannotCreateDatabase
    case failedToAddWeapon
}

class DatabaseManager {
    static let shared = DatabaseManager()
    
    func addWeapon(id: String, name: String, addedAt: Date, price: Double, stock: Int, imageUrl: String, location: String, status: Bool, completion: @escaping (Result<Void, Error>) -> Void){
        
        do {
            let realm = try Realm()
            
            let weapon = WeaponEntity()
            weapon.id = id
            weapon.name = name
            weapon.addedAt = addedAt
            weapon.price = price
            weapon.stock = stock
            weapon.imageUrl = imageUrl
            weapon.status = status
            weapon.location = location
            
            do {
                try realm.write {
                    realm.add(weapon)
                }
                completion(.success(()))
            } catch {
                completion(.failure(DatabaseError.failedToAddWeapon))
            }
        } catch {
            completion(.failure(DatabaseError.cannotCreateDatabase))
        }
        
    }
    
    func fetchWeapon() -> [WeaponEntity]{
        let realm = try! Realm()
        
        let dataWeapon = realm.objects(WeaponEntity.self)
            .sorted(byKeyPath: "addedAt", ascending: false)
        
        return dataWeapon.map { $0 }
    }
}
