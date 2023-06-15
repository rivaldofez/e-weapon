//
//  WeaponView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI

struct WeaponView: View {
    @State private var searchQuery: String = ""
    @StateObject private var viewModel: WeaponViewModel = WeaponViewModel()
    
    func deleteItems(at offsets: IndexSet){
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(viewModel.weapon, id: \.id){ weapon in
                        //                        Image(uiImage: getImage(imageUrl: weapon.imageUrl))
                        WeaponItemView(name: weapon.name, price: "Rp5.000.000,-", stock: "100", status: "Bengkel", image: getImage(imageUrl: weapon.imageUrl))
                            .hLeading()
                            .alignmentGuide(.listRowSeparatorLeading){ _ in
                                 0
                            }
                            .swipeActions {
                                Button {
                                    print("Delete")
                                } label: {
                                    Label("Delete", systemImage: "trash.circle.fill")
                                }
                                
                            }
                    }
                }
                .listStyle(.plain)
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
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                Text("Tambah")
                                
                            }
                        }
                        
                        Button {
                            
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                Text("Export")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getImage(imageUrl: String) -> UIImage {
        let imagesDefaultURL = URL(fileURLWithPath: "/images/")
        let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
        let imageUrl = imagesFolderUrl.appendingPathComponent(imageUrl)
        
        do {
            print(imageUrl.absoluteString)
            
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

struct WeaponView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponView()
    }
}
