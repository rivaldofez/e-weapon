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
    
    @State private var showFileExported: Bool = false
    
    @State private var csvDocument: CSVDocument = CSVDocument()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.weapon.isEmpty {
                        LottieView(name: "Empty", loopMode: .loop)
                            .frame(maxHeight: 240)
                        
                        Text("Oops, data empty or not found")
                        .font(.system(.title3).bold())
                        .foregroundColor(.primaryLabel)
                        .padding(.top, -16)
                        .padding(.horizontal, 16)
                } else {
                    List {
                        ForEach($viewModel.weapon, id: \.id){ $weapon in
                            NavigationLink {
                                DetailWeaponView(id: weapon.id, imageUrl: weapon.imageUrl , addedAt: weapon.addedAt ,name: weapon.name, price: "\(weapon.price)", stock: "\(weapon.stock)", currentImage: getImage(imageUrl: weapon.imageUrl), statusSelected: weapon.status, locationSelected: weapon.location)
                            } label: {
                                WeaponItemView(weapon: $weapon)
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
                            
                            var number = 0
                            var csvHead = "No,Name,Price,Stock,Status,Location\n"
                            
                            for weaponItem in viewModel.weapon {
                                number += 1
                                csvHead.append("\(number),\(weaponItem.name),\(weaponItem.price),\(weaponItem.stock),\(weaponItem.status),\(weaponItem.location)\n")
                            }
                            
                            self.csvDocument = CSVDocument(initialText: csvHead)
                            self.showFileExported = true
                            
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
                        .fileExporter(isPresented: $showFileExported, document: csvDocument, contentType: .commaSeparatedText, defaultFilename: "Weapon-Data") { result in
                            switch result {
                            case .success(let url):
                                print("Saved to \(url)")
                            case .failure(let error):
                                print(error.localizedDescription)
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

struct WeaponView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponView()
    }
}
