//
//  AddWeapon.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI
import UIKit

struct AddWeaponView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddWeaponViewModel = AddWeaponViewModel()
    
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
                    TitleSubForm(title: String(localized: "txt_weapon_information"))
                        .hLeading()
                    
                    CustomTextField(title: String(localized: "txt_name"), text: self.$name, iconName: "person")
                    
                    CustomTextField(title: String(localized: "txt_price"), text: self.$price,keyboardType: .numberPad, iconName: "tag")
                    
                    CustomTextField(title: String(localized: "txt_stock"), text: self.$stock,keyboardType: .numberPad, iconName: "shippingbox")
                }
                
                Group {
                    TitleSubForm(title: String(localized: "txt_status"))
                        .hLeading()
                        .padding(.top, 16)
                    CustomSegmentedControl(selectedItem: self.$statusSelected, items: Constants.statusOptions)
                    
                }
                
                Group {
                    TitleSubForm(title: String(localized: "txt_location"))
                        .hLeading()
                        .padding(.top, 16)
                    
                    CustomMenuPicker(menuItemSelection: self.$locationSelected, menus: Constants.locationOptions, title: "")
                }
                
                Group {
                    TitleSubForm(title: String(localized: "txt_image"))
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
                
                //                Button("Delete Weapon"){
                //                    DatabaseManager.shared.deleteWeapon(id: "B0404AF9-72E1-4037-805A-DC8EB5066DB2") { result in
                //                        switch(result){
                //                        case .success:
                //                            print("success delete")
                //                            print(DatabaseManager.shared.fetchWeapon())
                //                        case .failure(let error):
                //                            print("error")
                //                            print(error.localizedDescription)
                //                        }
                //                    }
                //                }
                
                //                Button("Load Image"){
                //                    let imagesDefaultURL = URL(fileURLWithPath: "/images/")
                //                    let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
                //                    let imageUrl = imagesFolderUrl.appendingPathComponent("B0404AF9-72E1-4037-805A-DC8EB5066DB2")
                //
                //                    do {
                //                        print(imageUrl.absoluteString)
                //
                //                        let imageData = try Data(contentsOf: imageUrl)
                //                        self.currentImage = UIImage(data: imageData)
                //
                //                    } catch {
                //                        print("Not able to load image")
                //                    }
                //
                //
                //                    //                let imagesDefaultURL = URL(fileURLWithPath: "/images/")
                //                    //                if let documentsUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                //                    //                        let fileURL = documentsUrl.appendingPathComponent("132A90A1-8420-4AB0-862C-2244B5A87FA7")
                //                    //                        do {
                //                    //                            let imageData = try Data(contentsOf: fileURL)
                //                    //                            self.currentImage = UIImage(data: imageData)
                //                    //
                //                    //                        } catch {
                //                    //                            print("Not able to load image")
                //                    //                        }
                //                    //                    }
                //
                //                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("txt_add_weapon")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                    if let price = Double(self.price), let stock = Int(self.stock),  let image = self.currentImage {
                        
                        viewModel.addWeapon(id: UUID().uuidString, name: self.name, addedAt: Date(), price: price, stock: stock, location: self.locationSelected, status: self.statusSelected, image: image) { result in
                            
                            switch(result) {
                            case .success:
                                showAlert(isActive: true, title: String(localized: "ttl_success"), message: String(localized: "msg_weapon_added"))
                                print(self.alertTitle)
                            case .failure(_):
                                showAlert(isActive: true, title: String(localized: "ttl_failed"), message: String(localized: "msg_failed_save_data"))
                            }
                        }
                    } else {
                        showAlert(isActive: true, title: String(localized: "ttl_fix_form"), message: String(localized: "msg_incorrect_form"))
                    }
                } label: {
                    Text("txt_save")
                }
                .disabled(!isFormValid())
                .tint(.primaryAccent)
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

struct TitleSubForm: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(.body).bold())
            .foregroundColor(.primaryAccent)
    }
}

struct AddImageSubForm: View {
    var strokeColor: Color = .primaryGray
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(systemName: "plus.app")
                .resizable()
                .frame(maxWidth: 90, maxHeight: 90)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.primaryAccent)
            
            Text("txt_add_photo")
                .font(.system(.body).bold())
                .padding(.top, 8)
                .foregroundColor(.primaryAccent)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding(24)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: 1, dash: [8]))
        }
    }
}

struct AddWeaponView_Previews: PreviewProvider {
    static var previews: some View {
        AddWeaponView()
    }
}
