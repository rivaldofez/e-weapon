//
//  AddWeapon.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI
import UIKit

struct AddWeaponView: View {
    @State private var id: String = ""
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var currentImage: UIImage? = nil
    
    @State private var showImageActionDialog: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showImagePickerSheet: Bool = false
    
    var body: some View {
        VStack {
            Text("Kode")
            TextField("Kode", text: self.$id)
            
            Text("Nama")
            TextField("Nama", text: self.$name)
            
            Text("Harga")
            TextField("Harga", text: self.$price)
            
            Button {
                self.showImageActionDialog = true
            } label: {
                if currentImage == nil {
                    Image(systemName: "person")
                } else {
                    if let currentImage = self.currentImage {
                        Image(uiImage: currentImage)
                    } else {
                        Image(systemName: "person")
                            .resizable()
                    }
                }
            }
            
            Button("Save"){
                DatabaseManager.shared.addWeapon(id: UUID().uuidString, name: name, addedAt: Date(), price: 0, stock: 0, imageUrl: "") { result in
                    switch(result){
                    case .success:
                        print("success save")
                        print(DatabaseManager.shared.fetchWeapon())
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }

        }
        .confirmationDialog("Choose Action To Do", isPresented: self.$showImageActionDialog){
            
            Button("Galeri"){
                self.showImagePickerSheet = true
                self.sourceType = .photoLibrary
            }
            
            Button("Kamera") {
                self.showImagePickerSheet = true
                self.sourceType = .camera
            }
            
            Button("Hapus Foto", role: .destructive) {
                self.currentImage = nil
            }
            
            Button("Batal", role: .cancel){
                
            }
            
        } message: {
            Text("Choose Action To Do")
        }
        .sheet(isPresented: self.$showImagePickerSheet){
            ImagePicker(image: self.$currentImage, isShown: self.$showImagePickerSheet, sourceType: self.sourceType)
        }
        
    }
}

struct AddWeaponView_Previews: PreviewProvider {
    static var previews: some View {
        AddWeaponView()
    }
}
