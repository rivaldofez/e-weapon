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
    
    @State var statusSelected: String = Constants.statusOptions[0]
    
    @State var locationSelected: String = ""
    
    
    @State private var isEdit: Bool = false
    
    @StateObject var viewModel: DetailWeaponViewModel = DetailWeaponViewModel()
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 10) {
                Group {
                    TitleSubForm(title: String(localized: "txt_weapon_information"))
                        .hLeading()
                    
                    CustomTextField(title: String(localized: "txt_name"), text: self.$name, iconName: "person", strokeColor: isEdit ? .secondaryAccent : .primaryGray)
                        .disabled(!isEdit)
                    
                    CustomTextField(title: String(localized: "txt_price"), text: self.$price,keyboardType: .numberPad, iconName: "tag",strokeColor: isEdit ? .secondaryAccent : .primaryGray)
                        .disabled(!isEdit)
                    
                    CustomTextField(title: String(localized: "txt_stock"), text: self.$stock,keyboardType: .numberPad, iconName: "shippingbox",strokeColor: isEdit ? .secondaryAccent : .primaryGray)
                        .disabled(!isEdit)
                }
                
                Group {
                    TitleSubForm(title: String(localized: "txt_status"))
                        .hLeading()
                        .padding(.top, 16)
                    CustomSegmentedControl(selectedItem: self.$statusSelected, items: Constants.statusOptions, strokeColor: isEdit ? .secondaryAccent : .primaryGray)
                        .disabled(!isEdit)
                    
                }
                
                Group {
                    TitleSubForm(title: String(localized: "txt_location"))
                        .hLeading()
                        .padding(.top, 16)
                    
                    CustomMenuPicker(menuItemSelection: self.$locationSelected, menus: Constants.locationOptions, title: "", strokeColor: isEdit ? .secondaryAccent : .primaryGray)
                        .disabled(!isEdit)
                }
                
                Group {
                    TitleSubForm(title: String(localized: "txt_image"))
                        .hLeading()
                        .padding(.top, 16)
                    
                    Button {
                        self.showImageActionDialog = true
                    } label: {
                        if currentImage == nil {
                            AddImageSubForm(strokeColor: isEdit ? .secondaryAccent : .primaryGray)
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
                                        .stroke(isEdit ? Color.secondaryAccent : Color.primaryGray, style: StrokeStyle(lineWidth: 2, dash: [10]))
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
        .navigationTitle("txt_detail_weapon")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isEdit {
                        
                        if let price = Double(self.price), let stock = Int(self.stock),  let image = self.currentImage {
                            
                            viewModel.updateWeapon(id: self.id, name: self.name, addedAt: Date(), price: price, stock: stock, location: self.locationSelected, status: self.statusSelected, imageUrl: imageUrl, image: image) { result in
                                switch(result){
                                case .success:
                                    showAlert(isActive: true, title: String(localized: "ttl_success"), message: String(localized: "msg_weapon_updated"))
                                case .failure(_):
                                    showAlert(isActive: true, title: String(localized: "ttl_failed"), message: String(localized: "msg_failed_save_data"))
                                }
                            }
                        }
                        
                        isEdit.toggle()
                    } else {
                        isEdit.toggle()
                    }
                } label: {
                    Text(isEdit ? String(localized: "txt_save") : String(localized: "txt_edit"))
                }
                .tint(isEdit ? .primaryAccent : .secondaryAccent)
                .disabled(!isFormValid())
                .alert(self.alertTitle, isPresented: self.$showAlert, actions: {
                    Button("txt_ok") {
                        if self.alertTitle == String(localized: "ttl_success"){
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }, message: {
                    Text(self.alertMessage)
                })
            }
        }
        
        .confirmationDialog("txt_choose_action_do", isPresented: self.$showImageActionDialog){
            
            Button("txt_gallery"){
                self.showImagePickerSheet = true
                self.sourceType = .photoLibrary
            }
            
            Button("txt_camera") {
                self.showImagePickerSheet = true
                self.sourceType = .camera
            }
            
            Button("txt_delete_photo", role: .destructive) {
                self.currentImage = nil
            }
            
            Button("txt_cancel", role: .cancel){
                
            }
            
        } message: {
            Text("txt_choose_action_do")
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
