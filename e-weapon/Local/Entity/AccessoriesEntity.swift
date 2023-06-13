//
//  AccessoriesEntity.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 13/06/23.
//

import Foundation
import RealmSwift

class AccessoriesEntity: Object {
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var addedAt: Date
    @Persisted var price : Double
    @Persisted var stock: Int
    @Persisted var imageUrl: String
    @Persisted var location: String
    @Persisted var status: String
    
}
