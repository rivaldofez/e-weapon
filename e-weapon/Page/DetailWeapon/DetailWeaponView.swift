//
//  DetalWeaponView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 15/06/23.
//

import SwiftUI

struct DetailWeaponView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    
    
    var id: String
    var imageUrl: String
    var addedAt: Date
    @State var name: String = ""
    @State var price: String = ""
    @State var stock: String = ""
    @State var currentImage: UIImage? = nil
    
    
    @State private var showImageActionDialog: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showImagePickerSheet: Bool = false
    
    var statusOptions = ["Save", "Used"]
    @State var statusSelected: String = "Save"
    
    @State var locationSelected: String = ""
    var locationOptions = ["Rumah", "Gudang", "Bengkel"]
    
    
    @State private var isEdit: Bool = false
    
    @StateObject var viewModel: DetailWeaponViewModel = DetailWeaponViewModel()
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 10) {
                Group {
                    TitleSubForm(title: "Weapon Information")
                        .hLeading()
                    
                    CustomTextField(title: "Name", text: self.$name, iconName: "person")
                        .disabled(!isEdit)
                    
                    CustomTextField(title: "Price", text: self.$price,keyboardType: .numberPad, iconName: "tag")
                        .disabled(!isEdit)
                    
                    CustomTextField(title: "Stock", text: self.$stock,keyboardType: .numberPad, iconName: "shippingbox")
                        .disabled(!isEdit)
                }
                
                Group {
                    TitleSubForm(title: "Status")
                        .hLeading()
                        .padding(.top, 16)
                    CustomSegmentedControl(selectedItem: self.$statusSelected, items: statusOptions)
                        .disabled(!isEdit)
                    
                }
                
                Group {
                    TitleSubForm(title: "Location")
                        .hLeading()
                        .padding(.top, 16)
                    
                    CustomMenuPicker(menuItemSelection: self.$locationSelected, menus: locationOptions, title: "")
                        .disabled(!isEdit)
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
                    .disabled(!isEdit)
                    
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
        .onAppear {
            print(imageUrl)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Add Weapon")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isEdit {
                        
                        if let price = Double(self.price), let stock = Int(self.stock),  let image = self.currentImage {
                            
                            viewModel.updateWeapon(id: self.id, name: self.name, addedAt: Date(), price: price, stock: stock, location: self.locationSelected, status: self.statusSelected, imageUrl: imageUrl, image: image) { result in
                                switch(result){
                                case .success:
                                    showAlert(isActive: true, title: "Success", message: "Weapon has been updated")
                                case .failure(_):
                                    showAlert(isActive: true, title: "Failed", message: "An error occured when update the data")
                                }
                            }
                        }
                        
                        isEdit.toggle()
                    } else {
                        print("Edit")
                        isEdit.toggle()
                    }
                } label: {
                    Text(isEdit ? "Save" : "Edit")
                }
                .disabled(!isFormValid())
                .alert(self.alertTitle, isPresented: self.$showAlert, actions: {
                    Button("OK") {
                        if self.alertTitle == "Success"{
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }, message: {
                    Text(self.alertMessage)
                })
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

struct DetailWeaponView_Previews: PreviewProvider {
    static var previews: some View {
        DetailWeaponView(id: "", imageUrl: "", addedAt: Date())
    }
}
