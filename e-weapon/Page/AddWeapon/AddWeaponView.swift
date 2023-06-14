//
//  AddWeapon.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI
import UIKit

struct AddWeaponView: View {
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
                    CustomSegmentedControl(selectedItem: self.$statusSelected, items: statusOptions, selectedBackgroundColor: .primaryAccent ,selectedTextColor: .primaryButtonLabel)
                    
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
                Button("Load Image"){
                    let imagesDefaultURL = URL(fileURLWithPath: "/images/")
                    let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
                    let imageUrl = imagesFolderUrl.appendingPathComponent("C3A24C67-272B-44D5-BF42-E9D245482FD8")

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
                    
                    if let price = Double(self.price), let stock = Int(self.stock),  let image = self.currentImage {
                        
                        viewModel.addWeapon(id: UUID().uuidString, name: self.name, addedAt: Date(), price: price, stock: stock, location: self.locationSelected, status: self.statusSelected, image: image) { result in
                            
                            switch(result) {
                            case .success:
                                print("success save")
                                print(DatabaseManager.shared.fetchWeapon())
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                } label: {
                    Text("Save")
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

struct TitleSubForm: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(.body).bold())
    }
}

struct AddImageSubForm: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(systemName: "plus.app")
                .resizable()
                .frame(maxWidth: 90, maxHeight: 90)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.primary)
            
            Text("Tambah Foto")
                .font(.system(.body).bold())
                .padding(.top, 8)
                .foregroundColor(.primary)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding(24)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black, style: StrokeStyle(lineWidth: 2, dash: [10]))
        }
    }
}

struct AddWeaponView_Previews: PreviewProvider {
    static var previews: some View {
        AddWeaponView()
    }
}
