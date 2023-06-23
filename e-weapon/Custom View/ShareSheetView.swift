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
            UIActivityViewController(activityItems: items, applicationActivities: nil)
        }

        func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheetView>) {

        }
        
    
}
