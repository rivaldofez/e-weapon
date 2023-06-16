//
//  Weapon.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 15/06/23.
//

import Foundation

struct Weapon: Equatable, Identifiable {
    var id: String
    var name: String
    var addedAt: Date
    var price : Double
    var stock: Int
    var imageUrl: String
    var location: String
    var status: String
}
