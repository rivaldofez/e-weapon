//
//  Helper.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 17/06/23.
//

import UIKit

class Helper {
    static func formattedAmount(amount: Double) -> String {
        return "Rp\(amount.formatted(FloatingPointFormatStyle()))"
    }
    
    /// Update NSData to buffer for xlsxwriter
    static func getArrayOfBytesFromImage(imageData: NSData) -> [UInt8] {
        //Determine array size
        let count = imageData.length / MemoryLayout.size(ofValue: UInt8())
        //Create an array of the appropriate size
        var bytes = [UInt8](repeating: 0, count: count)
        //Copy image data as bytes into the array
        imageData.getBytes(&bytes, length:count * MemoryLayout.size(ofValue: UInt8()))

        return bytes
    }
    
    static func minRatio(left: (Double, Double), right: (Double, Double)) -> Double {
        min(left.0 / right.0, left.1 / right.1)
    }
    
    static func getImage(imageUrl: String) -> UIImage {
        let imagesDefaultURL = URL(fileURLWithPath: "/images/")
        let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
        let imageUrl = imagesFolderUrl.appendingPathComponent(imageUrl)
        
        do {
            let imageData = try Data(contentsOf: imageUrl)
            
            if let imageResult = UIImage(data: imageData){
                return imageResult
            }
        } catch {
            print("Not able to load image")
        }
        
        return UIImage(systemName: "exclamationmark.triangle.fill")!
    }
}
