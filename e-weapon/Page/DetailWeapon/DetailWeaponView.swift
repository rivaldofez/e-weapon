//
//  DetalWeaponView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 15/06/23.
//

import SwiftUI

struct DetailWeaponView: View {
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var stock: String = ""
    @State private var currentImage: UIImage? = nil
    
    @State private var showImageActionDialog: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showImagePickerSheet: Bool = false
    
    var statusOptions = ["Save", "Used"]
    @State private var statusSelected: String = "Save"
    
    @State private var locationSelected: String = ""
    var locationOptions = ["Rumah", "Gudang", "Bengkel"]
    
    
    @State private var isEdit: Bool = false
    
    @StateObject var viewModel: AddWeaponViewModel = AddWeaponViewModel()
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 10) {
                Group {
                    TitleSubForm(title: "Weapon Information")
                        .hLeading()
                    
                    CustomTextField(title: "Name", text: self.$name, iconName: "person")
                    
                    CustomTextField(title: "Price", text: self.$price,keyboardType: .numberPad, iconName: "tag")
                    
                    CustomTextField(title: "Stock", text: self.$stock,keyboardType: .numberPad, iconName: "shippingbox")
                }
                
                Group {
                    TitleSubForm(title: "Status")
                        .hLeading()
                        .padding(.top, 16)
                    CustomSegmentedControl(selectedItem: self.$statusSelected, items: statusOptions)
                    
                }
                
                Group {
                    TitleSubForm(title: "Location")
                        .hLeading()
                        .padding(.top, 16)
                    
                    CustomMenuPicker(menuItemSelection: self.$locationSelected, menus: locationOptions, title: "")
                }
                
                Group {
                    TitleSubForm(title: "Image")
                        .hLeading()
                        .padding(.top, 16)
                    
                    Button {
                        self.showImageActionDialog = true
                    } label: {
                        if currentImage == nil {
                            AddImageSubForm()
                        } else {
                            Image(uiImage: self.currentImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, minHeight: 120)
                                .clipped()
                                .cornerRadius(8)
                                .padding(4)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.black, style: StrokeStyle(lineWidth: 2, dash: [10]))
                                }
                        }
                    }
                    
                }
                
                
                
                //                Button {
                //                    self.showImageActionDialog = true
                //                } label: {
                //                    if currentImage == nil {
                //                        Image(systemName: "person")
                //                    } else {
                //                        if let currentImage = self.currentImage {
                //                            Image(uiImage: currentImage)
                //                                .resizable()
                //                                .frame(width: 50, height: 50)
                //                        } else {
                //                            Image(systemName: "person")
                //                                .resizable()
                //                        }
                //                    }
                //                }
                
                Button("Delete Weapon"){
                    DatabaseManager.shared.deleteWeapon(id: "B0404AF9-72E1-4037-805A-DC8EB5066DB2") { result in
                        switch(result){
                        case .success:
                            print("success delete")
                            print(DatabaseManager.shared.fetchWeapon())
                        case .failure(let error):
                            print("error")
                            print(error.localizedDescription)
                        }
                    }
                }
                
                Button("Load Image"){
                    let imagesDefaultURL = URL(fileURLWithPath: "/images/")
                    let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
                    let imageUrl = imagesFolderUrl.appendingPathComponent("B0404AF9-72E1-4037-805A-DC8EB5066DB2")
                    
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
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Add Weapon")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isEdit {
                        print("Save")
                        isEdit.toggle()
                    } else {
                        print("Edit")
                        isEdit.toggle()
                    }
                } label: {
                    Text(isEdit ? "Save" : "Edit")
                }
                .disabled(!isFormValid())
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
    
    func isFormValid() -> Bool {
        if name.isEmpty {
            return false
        }
        
        if locationSelected.isEmpty {
            return false
        }
        
        if statusSelected.isEmpty {
            return false
        }
        
        if let _ = Double(self.price), let _ = Int(self.stock), let _ = self.currentImage {
            return true
        } else {
            return false
        }
    }
    
}

struct DetailWeaponView_Previews: PreviewProvider {
    static var previews: some View {
        DetailWeaponView()
    }
}
