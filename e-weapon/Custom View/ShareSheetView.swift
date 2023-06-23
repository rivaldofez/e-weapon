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
            
            var controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
            controller.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                if completed == true {
                    if let url = items.first as? URL {
                        try! FileManager.default.removeItem(at: url)
                    }
                }
            }
            return controller
        }

        func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheetView>) {

        }
        
    
}
