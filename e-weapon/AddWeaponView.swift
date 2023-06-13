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
                            .resizable()
                            .frame(width: 50, height: 50)
                    } else {
                        Image(systemName: "person")
                            .resizable()
                    }
                }
            }
            Button("Load Image"){
                let imagesDefaultURL = URL(fileURLWithPath: "/images/")
                let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
                let imageUrl = imagesFolderUrl.appendingPathComponent("0831C0DA-4ECB-45EA-8FA8-41D71E1025C8")
                
                do {
                    print(imageUrl.absoluteString)
                    
                    let imageData = try Data(contentsOf: imageUrl)
                    self.currentImage = UIImage(data: imageData)
                    
                } catch {
                    print("Not able to load image")
                }
                
                
                //                let imagesDefaultURL = URL(fileURLWithPath: "/images/")
                //                if let documentsUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                //                        let fileURL = documentsUrl.appendingPathComponent("132A90A1-8420-4AB0-862C-2244B5A87FA7")
                //                        do {
                //                            let imageData = try Data(contentsOf: fileURL)
                //                            self.currentImage = UIImage(data: imageData)
                //
                //                        } catch {
                //                            print("Not able to load image")
                //                        }
                //                    }
                
            }
            
            Button("Save"){
                let id = UUID().uuidString
                let imagesDefaultURL = URL(fileURLWithPath: "/images/")
                let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
                
                let imageData = currentImage?.pngData()
                let imageName = id
                
                let imageUrl = imagesFolderUrl.appendingPathComponent(imageName)
                
                if let imageData = imageData {
                    do {
                        try imageData.write(to: imageUrl)
                        print(imageUrl.absoluteString)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                
                DatabaseManager.shared.addWeapon(id: UUID().uuidString, name: name, addedAt: Date(), price: 0, stock: 0, imageUrl: imageName,location: "", status: "") { result in
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
