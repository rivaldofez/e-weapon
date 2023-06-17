//
//  Accessory.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 17/06/23.
//

import SwiftUI

struct Accessory: Equatable, Identifiable {
    var id: String
    var name: String
    var addedAt: Date
    var price : Double
    var stock: Int
    var imageUrl: String
    var location: String
    var status: String
}
