//
//  Helper.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 17/06/23.
//

import Foundation

class Helper {
    static func formattedAmount(amount: Double) -> String {
        return "Rp\(amount.formatted(FloatingPointFormatStyle()))"
    }
}
