//
//  AccessoryView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 17/06/23.
//

import SwiftUI

struct AccessoryView: View {
    @State private var searchQuery: String = ""
    
    @StateObject private var viewModel: AccessoryViewModel = AccessoryViewModel()
    
    @State private var showShareSheet: Bool = false
    @State private var showFormatExportDialog: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.accessories.isEmpty {
                        LottieView(name: "Empty", loopMode: .loop)
                            .frame(maxHeight: 240)
                        
                        Text("msg_data_empty")
                        .font(.system(.title3).bold())
                        .foregroundColor(.primaryLabel)
                        .padding(.top, -16)
                        .padding(.horizontal, 16)
                } else {
                    List {
                        ForEach($viewModel.accessories, id: \.id){ $accessory in
                            NavigationLink {
                                DetailAccessoryView(id: accessory.id, imageUrl: accessory.imageUrl , addedAt: accessory.addedAt ,name: accessory.name, price: "\(accessory.price)", stock: "\(accessory.stock)", currentImage: Helper.getImage(imageUrl: accessory.imageUrl), statusSelected: accessory.status, locationSelected: accessory.location)
                            } label: {
                                AccessoryItemView(accessory: $accessory)
                                    .hLeading()
                                    .alignmentGuide(.listRowSeparatorLeading){ _ in
                                        0
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                viewModel.deleteAccessory(id: accessory.id) { result in
                                                    switch(result){
                                                    case .success :
                                                        viewModel.fetchAccessory()
                                                    case .failure(let error):
                                                        print("error")
                                                        print(error.localizedDescription)
                                                    }
                                                }
                                            }
                                        } label: {
                                            Label("txt_delete", systemImage: "trash.circle.fill")
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
                viewModel.fetchAccessory()
            }
            .onChange(of: self.searchQuery){ newQuery in
                withAnimation {
                    viewModel.filterSearch(query: newQuery)
                }
            }
            .searchable(text: self.$searchQuery)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Text("txt_accessories")
                        .font(.system(.title).bold())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(alignment: .center, spacing: 0) {
                        NavigationLink {
                            AddAccessoryView()
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "plus.circle")
                                    .font(.system(.title3))
                                    .foregroundColor(.primaryAccent)
                                Text("txt_add_new")
                                    .font(.system(.body))
                                    .foregroundColor(.primaryAccent)
                                
                            }
                        }
                        
                        Button {
                            if (viewModel.accessories.isEmpty){
                                showAlert(isActive: true, title: String(localized: "ttl_data_not_valid"), message: String(localized: "msg_export_data_empty"))
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
                        .confirmationDialog("txt_choose_document_type", isPresented: self.$showFormatExportDialog){
                            
                            Button("txt_excel_format"){
                                viewModel.generateExcelFile()
                                if(viewModel.documentItemsExport.isEmpty){
                                    showAlert(isActive: true, title: String(localized: "ttl_cannot_create_excel_doc"), message: String(localized: "msg_please_check_data"))
                                } else {
                                    self.showShareSheet.toggle()
                                }
                            }
                            
                            Button("txt_csv_format") {
                                viewModel.generateCSVFile()
                                if(viewModel.documentItemsExport.isEmpty){
                                    showAlert(isActive: true, title: String(localized: "ttl_cannot_create_csv_doc"), message: String(localized: "Please check again your data and try again later"))
                                } else {
                                    self.showShareSheet.toggle()
                                }
                            }
                            
                            Button("txt_cancel", role: .cancel){
                                
                            }
                            
                        } message: {
                            Text("txt_format_export_doc")
                        }
                        .sheet(isPresented: self.$showShareSheet) {
                            ShareSheetView(items: $viewModel.documentItemsExport)
                        }
                        .alert(self.alertTitle, isPresented: self.$showAlert, actions: {
                            Button("txt_ok") {
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

struct AccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        AccessoryView()
    }
}
