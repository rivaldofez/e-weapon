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
    
    @State private var showFileExported: Bool = false
    
    @State private var csvDocument: CSVDocument = CSVDocument()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.accessories.isEmpty {
                        LottieView(name: "Empty", loopMode: .loop)
                            .frame(maxHeight: 240)
                        
                        Text("Oops, data empty or not found")
                        .font(.system(.title3).bold())
                        .foregroundColor(.primaryLabel)
                        .padding(.top, -16)
                        .padding(.horizontal, 16)
                } else {
                    List {
                        ForEach($viewModel.accessories, id: \.id){ $accessory in
                            NavigationLink {
                                DetailAccessoryView(id: accessory.id, imageUrl: accessory.imageUrl , addedAt: accessory.addedAt ,name: accessory.name, price: "\(accessory.price)", stock: "\(accessory.stock)", currentImage: getImage(imageUrl: accessory.imageUrl), statusSelected: accessory.status, locationSelected: accessory.location)
                            } label: {
                                AccessoryItemView(accessory: $accessory)
                                    .hLeading()
                                    .alignmentGuide(.listRowSeparatorLeading){ _ in
                                        0
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            
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
                viewModel.fetchAccessory()
            }
            .searchable(text: self.$searchQuery)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Text("Accessories")
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
                                Text("Tambah")
                                    .font(.system(.body))
                                    .foregroundColor(.primaryAccent)
                                
                            }
                        }
                        
                        Button {
                            
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
                        
                    }
                }
            }
        }
        .tint(.secondaryAccent)
    }
    
    func getImage(imageUrl: String) -> UIImage {
        let imagesDefaultURL = URL(fileURLWithPath: "/images/")
        let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
        let imageUrl = imagesFolderUrl.appendingPathComponent(imageUrl)
        
        do {
            let imageData = try Data(contentsOf: imageUrl)
            
            if let imageResult = UIImage(data: imageData){
                return imageResult
            }
        } catch {
            print("Not able to load image")
        }
        
        return UIImage(systemName: "exclamationmark.triangle.fill")!
        
    }
}

struct AccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        AccessoryView()
    }
}
