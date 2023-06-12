//
//  AddWeapon.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI

struct AddWeaponView: View {
    @State private var id: String = ""
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var currentImage: UIImage? = nil
    
    @State private var showImageActionDialog: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera

    
    
    
    
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

        }
        .confirmationDialog("Choose Action To Do", isPresented: self.$showImageActionDialog){
            
            Button("Galeri"){
                
            }
            
            Button("Kamera") {
                
            }
            
            Button("Hapus Foto", role: .destructive) {
                
            }
            
            Button("Batal", role: .cancel){
                
            }
            
        } message: {
            Text("Choose Action To Do")
        }
        
    }
}

struct AddWeaponView_Previews: PreviewProvider {
    static var previews: some View {
        AddWeaponView()
    }
}
