//
//  ShareSheetView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 23/06/23.
//

import UIKit
import SwiftUI

struct ShareSheetView: UIViewControllerRepresentable {
    var items: [Any]
    
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
        
    
}
