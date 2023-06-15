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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(viewModel.weapon, id: \.id){ weapon in
                        NavigationLink {
                            DetailWeaponView(name: weapon.name, price: "\(weapon.price)", stock: "\(weapon.stock)", currentImage: getImage(imageUrl: weapon.imageUrl), statusSelected: weapon.status, locationSelected: weapon.location)
                        } label: {
                            WeaponItemView(name: weapon.name, price: "Rp\(weapon.price)", stock: "\(weapon.stock)", status: weapon.status, image: getImage(imageUrl: weapon.imageUrl))
                                .hLeading()
                                .alignmentGuide(.listRowSeparatorLeading){ _ in
                                     0
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteWeapon(id: weapon.id) { result in
                                            switch(result){
                                            case .success :
                                                viewModel.fetchWeapon()
                                            case .failure(let error):
                                                print("error")
                                                print(error.localizedDescription)
                                            }
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash.circle.fill")
                                    }
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

struct WeaponView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponView()
    }
}
