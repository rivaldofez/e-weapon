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
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0..<30, id: \.self){ weapon in
    //                        Image(uiImage: getImage(imageUrl: weapon.imageUrl))
                            HStack(alignment: .center) {
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 24)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Palu Gada")
                                        .font(.system(.title3).bold())
                                    
                                    HStack {
                                        Text("Rp.160.000,-")
                                            .font(.system(.body))
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Image(systemName: "shippingbox.fill")
                                            Text("4")
                                            Spacer()
                                        }
                                        .padding(.trailing, 8)
                                        .frame(width: 90)
                                    }
                                    
                                    
                                }
                            }
                            .hLeading()
                            .background(.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top)
                            
                        }
                    }
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
