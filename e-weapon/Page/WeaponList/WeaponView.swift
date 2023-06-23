//
//  WeaponView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI
import xlsxwriter


struct WeaponView: View {
    @State private var searchQuery: String = ""
    
    @StateObject private var viewModel: WeaponViewModel = WeaponViewModel()
    
    @State private var showShareSheet: Bool = false
    @State private var showFormatExportDialog: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.weapons.isEmpty {
                    LottieView(name: "Empty", loopMode: .loop)
                        .frame(maxHeight: 240)
                    
                    Text("Oops, data empty or not found")
                        .font(.system(.title3).bold())
                        .foregroundColor(.primaryLabel)
                        .padding(.top, -16)
                        .padding(.horizontal, 16)
                } else {
                    List {
                        ForEach($viewModel.weapons, id: \.id){ $weapon in
                            NavigationLink {
                                DetailWeaponView(id: weapon.id, imageUrl: weapon.imageUrl , addedAt: weapon.addedAt ,name: weapon.name, price: "\(weapon.price)", stock: "\(weapon.stock)", currentImage: Helper.getImage(imageUrl: weapon.imageUrl), statusSelected: weapon.status, locationSelected: weapon.location)
                            } label: {
                                WeaponItemView(weapon: $weapon)
                                    .hLeading()
                                    .alignmentGuide(.listRowSeparatorLeading){ _ in
                                        0
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                viewModel.deleteWeapon(id: weapon.id) { result in
                                                    switch(result){
                                                    case .success :
                                                        viewModel.fetchWeapon()
                                                    case .failure(let error):
                                                        print("error")
                                                        print(error.localizedDescription)
                                                    }
                                                }
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash.circle.fill")
                                        }
                                        .tint(.red)
                                    }
                            }
                            
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .onAppear {
                viewModel.fetchWeapon()
            }
            .onChange(of: self.searchQuery){ newQuery in
                withAnimation {
                    viewModel.filterSearch(query: newQuery)
                }
            }
            .searchable(text: self.$searchQuery)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Text("Weapon")
                        .font(.system(.title).bold())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(alignment: .center, spacing: 0) {
                        NavigationLink {
                            AddWeaponView()
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "plus.circle")
                                    .font(.system(.title3))
                                    .foregroundColor(.primaryAccent)
                                Text("Tambah")
                                    .font(.system(.body))
                                    .foregroundColor(.primaryAccent)
                                
                            }
                        }
                        
                        Button {
                            if (viewModel.weapons.isEmpty){
                                showAlert(isActive: true, title: "Data Not Valid or Empty", message: "To Export data, you must have non empty list data")
                            } else {
                                self.showFormatExportDialog = true
                            }
                            
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "square.and.arrow.up.circle")
                                    .font(.system(.title3))
                                    .foregroundColor(.secondaryAccent)
                                Text("Export")
                                    .font(.system(.body))
                                    .foregroundColor(.secondaryAccent)
                                
                            }
                        }
                        .confirmationDialog("Choose Document Type", isPresented: self.$showFormatExportDialog){
                            
                            Button("Microsot Excel (xlsx)"){
                                viewModel.generateExcelFile()
                                if(viewModel.documentItemsExport.isEmpty){
                                    showAlert(isActive: true, title: "Cannot Create Excel Document", message: "Please check again your data and try again later")
                                } else {
                                    self.showShareSheet.toggle()
                                }
                            }
                            
                            Button("Comma Separated Value (csv)") {
                                viewModel.generateCSVFile()
                                if(viewModel.documentItemsExport.isEmpty){
                                    showAlert(isActive: true, title: "Cannot Create CSV Document", message: "Please check again your data and try again later")
                                } else {
                                    self.showShareSheet.toggle()
                                }
                            }
                            
                            Button("Batal", role: .cancel){
                                
                            }
                            
                        } message: {
                            Text("Format export of document")
                        }
                        .sheet(isPresented: self.$showShareSheet) {
                            ShareSheetView(items: $viewModel.documentItemsExport)
                        }
                        .alert(self.alertTitle, isPresented: self.$showAlert, actions: {
                            Button("OK") {
                            }
                        }, message: {
                            Text(self.alertMessage)
                        })
                    }
                }
            }
        }
        .tint(.secondaryAccent)
    }
    
    private func showAlert(isActive: Bool, title: String ,message: String){
        self.showAlert = isActive
        self.alertMessage = message
        self.alertTitle = title
    }
}

struct WeaponView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponView()
    }
}
