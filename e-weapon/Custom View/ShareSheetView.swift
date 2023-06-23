//
//  ShareSheetView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 23/06/23.
//

import UIKit
import SwiftUI

struct ShareSheetView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    
    @Binding var items: [Any]
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheetView>) -> UIActivityViewController {
        
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if let url = items.first as? URL {
                try! FileManager.default.removeItem(at: url)
                items.removeAll()
            }
            
            print("called")
        }
        
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheetView>) {
        
    }
    
    
}
