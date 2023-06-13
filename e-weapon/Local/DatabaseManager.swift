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
    case failedToAddAccessory
}

class DatabaseManager {
    static let shared = DatabaseManager()
    
    func addWeapon(id: String, name: String, addedAt: Date, price: Double, stock: Int, imageUrl: String, location: String, status: String, completion: @escaping (Result<Void, Error>) -> Void){
        
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
    
    func addAccessories(id: String, name: String, addedAt: Date, price: Double, stock: Int, imageUrl: String, location: String, status: String, completion: @escaping (Result<Void, Error>) -> Void){
        
        do {
            let realm = try Realm()
            
            let accessory = AccessoryEntity()
            accessory.id = id
            accessory.name = name
            accessory.addedAt = addedAt
            accessory.price = price
            accessory.stock = stock
            accessory.imageUrl = imageUrl
            accessory.status = status
            accessory.location = location
            
            do {
                try realm.write {
                    realm.add(accessory)
                }
                completion(.success(()))
            } catch {
                completion(.failure(DatabaseError.failedToAddAccessory))
            }
        } catch {
            completion(.failure(DatabaseError.cannotCreateDatabase))
        }
    }
    
    func fetchAccessory() -> [AccessoryEntity] {
        let realm = try! Realm()
        
        let dataAccessory = realm.objects(AccessoryEntity.self)
            .sorted(byKeyPath: "addedAt", ascending: false)
        
        return dataAccessory.map { $0 }
    }
    
    func fetchWeapon() -> [WeaponEntity]{
        let realm = try! Realm()
        
        let dataWeapon = realm.objects(WeaponEntity.self)
            .sorted(byKeyPath: "addedAt", ascending: false)
        
        return dataWeapon.map { $0 }
    }
}
