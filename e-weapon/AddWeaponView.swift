//
//  AddWeapon.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI

struct AddWeaponView: View {
    @State private var id: String = ""
    @State private var name: String = ""
    @State private var price: String = ""
    
    
    
    var body: some View {
        VStack {
            Text("Kode")
            TextField("Kode", text: self.$id)
            
            Text("Nama")
            TextField("Nama", text: self.$name)
            
            Text("Harga")
            TextField("Harga", text: self.$price)
        }
    }
}

struct AddWeaponView_Previews: PreviewProvider {
    static var previews: some View {
        AddWeaponView()
    }
}
