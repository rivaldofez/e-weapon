//
//  CustomTextField.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 13/06/23.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    
    var strokeColor: Color = .gray
    var textColor: Color = .primary
    
    
    var body: some View {
        TextField("Nama", text: self.$text)
            .font(.system(.body))
            .padding(.all, 16)
            .foregroundColor(textColor)
        
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(strokeColor)
            }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(title: "Name", text: .constant("Rivaldo Fernandes"))
    }
}
