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
    
    func addGame(id: String, name: String, addedAt: Date, price: Double, stock: Int, imageUrl: String, completion: @escaping (Result<Void, Error>) -> Void){
        
        do {
            let realm = try Realm()
            
            let weapon = WeaponEntity()
            weapon.id = id
            weapon.name = name
            weapon.addedAt = addedAt
            weapon.price = price
            weapon.stock = stock
            weapon.imageUrl = imageUrl
            
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
}
