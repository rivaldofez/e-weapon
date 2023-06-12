//
//  WeaponEntity.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import Foundation
import RealmSwift

class WeaponEntity: Object {
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var addedAt: Date
    @Persisted var price : Double
    @Persisted var stock: Int
    @Persisted var imageUrl: String
}
