//
//  DatabaseManager.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import Foundation
import RealmSwift
import UIKit


enum DatabaseError: Error {
    case usernameExist
    case failedToFetchData
    case cannotCreateDatabase
    case failedToAddWeapon
    case failedToAddAccessory
    case failedToSaveImage
    case imageDataNotValid
    case imageDataNotFound
    case dataNotFound
    case cannotDeleteImage
    case cannotDeleteWeapon
    case cannotDeleteAccessory
    case failedToUpdateWeapon
    case failedToUpdateAccessory
}

class DatabaseManager {
    static let shared = DatabaseManager()
    
    func getImage(imageUrl: String) -> UIImage {
        let imagesDefaultURL = URL(fileURLWithPath: "/images/")
        let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
        let imageUrl = imagesFolderUrl.appendingPathComponent(imageUrl)
        
        do {
            print(imageUrl.absoluteString)
            
            let imageData = try Data(contentsOf: imageUrl)
            
            if let imageResult = UIImage(data: imageData){
                return imageResult
            }
        } catch {
            print("Not able to load image")
        }
        
        return UIImage(systemName: "exclamationmark.triangle.fill")!
        
    }
    
    func deleteImageAt(imageName: String) -> Bool {
        let imagesDefaultURL = URL(fileURLWithPath: "/images/")
        let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
        let imageUrl = imagesFolderUrl.appendingPathComponent(imageName)
        
        if FileManager.default.fileExists(atPath: imageUrl.relativePath){
            do {
                try FileManager.default.removeItem(at: imageUrl)
                return true
            } catch {
                return false
            }
        }
        
        return false
    }
    
    func deleteWeapon(id: String, completion: @escaping (Result<Void, Error>) -> Void){
        do {
            let realm = try Realm()

            if let weapon = getWeaponById(id: id){
                let imagesDefaultURL = URL(fileURLWithPath: "/images/")
                let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
                let imageUrl = imagesFolderUrl.appendingPathComponent(weapon.imageUrl)
                
                if FileManager.default.fileExists(atPath: imageUrl.relativePath) {
                    do {
                        try FileManager.default.removeItem(at: imageUrl)
                        do {
                            try realm.write {
                                realm.delete(weapon)
                            }
                            completion(.success(()))
                        } catch {
                            completion(.failure(DatabaseError.cannotDeleteWeapon))
                        }
                    } catch {
                        completion(.failure(DatabaseError.cannotDeleteImage))
                    }
                } else {
                    completion(.failure(DatabaseError.imageDataNotFound))
                }
            } else {
                completion(.failure(DatabaseError.dataNotFound))
            }
        } catch {
            completion(.failure(DatabaseError.cannotCreateDatabase))
        }
    }
    
    func deleteAccessory(id: String, completion: @escaping (Result<Void, Error>) -> Void){
        do {
            let realm = try Realm()

            if let accessory = getAccessoryById(id: id){
                let imagesDefaultURL = URL(fileURLWithPath: "/images/")
                let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
                let imageUrl = imagesFolderUrl.appendingPathComponent(accessory.imageUrl)
                
                if FileManager.default.fileExists(atPath: imageUrl.relativePath) {
                    do {
                        try FileManager.default.removeItem(at: imageUrl)
                        do {
                            try realm.write {
                                realm.delete(accessory)
                            }
                            completion(.success(()))
                        } catch {
                            completion(.failure(DatabaseError.cannotDeleteAccessory))
                        }
                    } catch {
                        completion(.failure(DatabaseError.cannotDeleteImage))
                    }
                } else {
                    completion(.failure(DatabaseError.imageDataNotFound))
                }
            } else {
                completion(.failure(DatabaseError.dataNotFound))
            }
        } catch {
            completion(.failure(DatabaseError.cannotCreateDatabase))
        }
    }
    
    private func getWeaponById(id: String) -> WeaponEntity? {
        do {
            let realm = try Realm()
            let resultWeapon = realm.objects(WeaponEntity.self)
                .where { $0.id == id }
            return resultWeapon.map { $0 }.first
            
        } catch {
            
            print(error.localizedDescription)
            return nil
            
        }
    }
    
    private func getAccessoryById(id: String) -> AccessoryEntity? {
        do {
            let realm = try Realm()
            let resultAccessory = realm.objects(AccessoryEntity.self)
                .where { $0.id == id }
            return resultAccessory.map { $0 }.first
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func generateImageName(id: String) -> String {
        return "\(id)-\(UUID().uuidString)"
    }
    
    
    func updateWeapon(id: String, name: String, addedAt: Date, price: Double, stock: Int, location: String, status: String, imageUrl: String, image: UIImage , completion: @escaping (Result<Void, Error>) -> Void){
        
        if deleteImageAt(imageName: imageUrl){
            let imagesDefaultUrl = URL(fileURLWithPath: "/images/")
            let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultUrl, create: true)

            let imageName = generateImageName(id: id)
            let imageData = image.jpegData(compressionQuality: 0.5)
            let imageLocalUrl = imagesFolderUrl.appendingPathComponent(imageName)

            if let imageData = imageData {
                if let weapon = getWeaponById(id: id){
                    do {
                        try imageData.write(to: imageLocalUrl)
                        do {
                            let realm = try Realm()
                            
                            do {
                                try realm.write {
                                    weapon.id = id
                                    weapon.name = name
                                    weapon.addedAt = addedAt
                                    weapon.price = price
                                    weapon.stock = stock
                                    weapon.imageUrl = imageName
                                    weapon.status = status
                                    weapon.location = location
                                }
                                completion(.success(()))
                            } catch {
                                completion(.failure(DatabaseError.failedToUpdateWeapon))
                            }
                        } catch {
                            completion(.failure(DatabaseError.cannotCreateDatabase))
                        }
                    } catch {
                        completion(.failure(DatabaseError.failedToSaveImage))
                        print("fail to save image")
                    }
                } else {
                    completion(.failure(DatabaseError.dataNotFound))
                    print("data not found")
                }
            } else {
                completion(.failure(DatabaseError.imageDataNotValid))
                print("not valid image")
            }
        } else {
            completion(.failure(DatabaseError.cannotDeleteImage))
            print("cannot delete image")
        }
    }
    
    func updateAccessory(id: String, name: String, addedAt: Date, price: Double, stock: Int, location: String, status: String, imageUrl: String, image: UIImage , completion: @escaping (Result<Void, Error>) -> Void){
        
        if deleteImageAt(imageName: imageUrl){
            let imagesDefaultUrl = URL(fileURLWithPath: "/images/")
            let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultUrl, create: true)

            let imageName = generateImageName(id: id)
            let imageData = image.jpegData(compressionQuality: 0.5)
            let imageLocalUrl = imagesFolderUrl.appendingPathComponent(imageName)

            if let imageData = imageData {
                if let accessory = getAccessoryById(id: id){
                    do {
                        try imageData.write(to: imageLocalUrl)
                        do {
                            let realm = try Realm()
                            
                            do {
                                try realm.write {
                                    accessory.id = id
                                    accessory.name = name
                                    accessory.addedAt = addedAt
                                    accessory.price = price
                                    accessory.stock = stock
                                    accessory.imageUrl = imageName
                                    accessory.status = status
                                    accessory.location = location
                                }
                                completion(.success(()))
                            } catch {
                                completion(.failure(DatabaseError.failedToUpdateAccessory))
                            }
                        } catch {
                            completion(.failure(DatabaseError.cannotCreateDatabase))
                        }
                    } catch {
                        completion(.failure(DatabaseError.failedToSaveImage))
                        print("fail to save image")
                    }
                } else {
                    completion(.failure(DatabaseError.dataNotFound))
                    print("data not found")
                }
            } else {
                completion(.failure(DatabaseError.imageDataNotValid))
                print("not valid image")
            }
        } else {
            completion(.failure(DatabaseError.cannotDeleteImage))
            print("cannot delete image")
        }
    }
    
    
    func addWeapon(id: String, name: String, addedAt: Date, price: Double, stock: Int, location: String, status: String, image: UIImage , completion: @escaping (Result<Void, Error>) -> Void){
        
        let imagesDefaultUrl = URL(fileURLWithPath: "/images/")
        let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultUrl, create: true)

        let imageData = image.jpegData(compressionQuality: 0.5)
        let imageName = generateImageName(id: id)
        let imageLocalUrl = imagesFolderUrl.appendingPathComponent(imageName)

        if let imageData = imageData {
            do {
                try imageData.write(to: imageLocalUrl)
                do {
                    let realm = try Realm()
                    
                    let weapon = WeaponEntity()
                    weapon.id = id
                    weapon.name = name
                    weapon.addedAt = addedAt
                    weapon.price = price
                    weapon.stock = stock
                    weapon.imageUrl = imageName
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
            } catch {
                completion(.failure(DatabaseError.failedToSaveImage))
            }
        } else {
            completion(.failure(DatabaseError.imageDataNotValid))
        }
    }
    
    func addAccessory(id: String, name: String, addedAt: Date, price: Double, stock: Int, location: String, status: String, image: UIImage , completion: @escaping (Result<Void, Error>) -> Void){
        
        let imagesDefaultUrl = URL(fileURLWithPath: "/images/")
        let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultUrl, create: true)

        let imageData = image.jpegData(compressionQuality: 0.5)
        let imageName = generateImageName(id: id)
        let imageLocalUrl = imagesFolderUrl.appendingPathComponent(imageName)

        if let imageData = imageData {
            do {
                try imageData.write(to: imageLocalUrl)
                do {
                    let realm = try Realm()
                    
                    let accessory = AccessoryEntity()
                    accessory.id = id
                    accessory.name = name
                    accessory.addedAt = addedAt
                    accessory.price = price
                    accessory.stock = stock
                    accessory.imageUrl = imageName
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
            } catch {
                completion(.failure(DatabaseError.failedToSaveImage))
            }
        } else {
            completion(.failure(DatabaseError.imageDataNotValid))
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
