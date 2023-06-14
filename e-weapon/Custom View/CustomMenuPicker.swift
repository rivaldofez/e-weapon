//
//  CustomMenuPicker.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 13/06/23.
//

import SwiftUI

struct CustomMenuPicker: View {
    @Binding var menuItemSelection: String
    var menus: [String]
    var title: String
    var cornerRadius: CGFloat = 8
    
    var body: some View {
        Menu {
            Picker(selection: self.$menuItemSelection) {
                ForEach(menus, id: \.self) {
                    Text($0)
                }
            } label: {
                Text(self.title)
                    .font(.body)
                    .foregroundColor(menuItemSelection.isEmpty ? .gray : .black)
            }
            
        } label: {
            HStack {
                Text(menuItemSelection.isEmpty ? "Select Category" : menuItemSelection)
                    .font(.body)
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .font(.system(.body))
            }
        }
        .foregroundColor(menuItemSelection.isEmpty ? .gray : .black)
        .padding(.all, 16)
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(.black)
        }
    }
}

struct CustomMenuPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomMenuPicker(menuItemSelection: .constant("Satu"), menus: ["Satu", "Dua", "Tiga", "Empat"], title: "Angka")
    }
}
