//
//  WeaponView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI

struct WeaponView: View {
    @State private var searchQuery: String = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .searchable(text: self.$searchQuery)
//            .navigationTitle("Weapon")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Text("Weapon")
                        .font(.system(.title).bold())
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(alignment: .center, spacing: 0) {
                        Button {

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
}

struct WeaponView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponView()
    }
}
