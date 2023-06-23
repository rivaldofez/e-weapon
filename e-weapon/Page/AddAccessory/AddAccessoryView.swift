//
//  AddAccessory.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 17/06/23.
//

import SwiftUI

struct AddAccessoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddAccessoryViewModel = AddAccessoryViewModel()
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var stock: String = ""
    @State private var currentImage: UIImage? = nil
    @State private var statusSelected: String = Constants.statusOptions[0]
    @State private var locationSelected: String = ""
    
    @State private var showImageActionDialog: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showImagePickerSheet: Bool = false
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 10) {
                Group {
                    TitleSubForm(title: "Accessory Information")
                        .hLeading()
                    
                    CustomTextField(title: "Name", text: self.$name, iconName: "person")
                    
                    CustomTextField(title: "Price", text: self.$price,keyboardType: .numberPad, iconName: "tag")
                    
                    CustomTextField(title: "Stock", text: self.$stock,keyboardType: .numberPad, iconName: "shippingbox")
                }
                
                Group {
                    TitleSubForm(title: "Status")
                        .hLeading()
                        .padding(.top, 16)
                    CustomSegmentedControl(selectedItem: self.$statusSelected, items: Constants.statusOptions)
                    
                }
                
                Group {
                    TitleSubForm(title: "Location")
                        .hLeading()
                        .padding(.top, 16)
                    
                    CustomMenuPicker(menuItemSelection: self.$locationSelected, menus: Constants.locationOptions, title: "")
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
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Add Accessory")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                    if let price = Double(self.price), let stock = Int(self.stock),  let image = self.currentImage {
                        
                        viewModel.addAccessory(id: UUID().uuidString, name: self.name, addedAt: Date(), price: price, stock: stock, location: self.locationSelected, status: self.statusSelected, image: image) { result in
                            
                            switch(result) {
                            case .success:
                                showAlert(isActive: true, title: "Success", message: "Accessory has been added")
                            case .failure(_):
                                showAlert(isActive: true, title: "Failed", message: "An error occured when save the data")
                            }
                        }
                    }
                } label: {
                    Text("Save")
                }
                .tint(.primaryAccent)
                .alert(self.alertTitle, isPresented: self.$showAlert, actions: {
                    Button("OK") {
                        if self.alertTitle == "Success"{
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }, message: {
                    Text(self.alertMessage)
                })
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
    
    private func showAlert(isActive: Bool, title: String ,message: String){
        self.showAlert = isActive
        self.alertMessage = message
        self.alertTitle = title
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

struct AddAccessory_Previews: PreviewProvider {
    static var previews: some View {
        AddAccessoryView()
    }
}
