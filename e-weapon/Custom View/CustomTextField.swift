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
    var keyboardType: UIKeyboardType = .default
    
    var iconName: String = "person"
    var iconColor: Color = .primary
    
    var strokeColor: Color = .gray
    var textColor: Color = .primary
    
    
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(.title3))
                .padding(.leading, 8)
                .foregroundColor(iconColor)
            
            
            TextField(title, text: self.$text)
                .font(.system(.body))
                .padding(.vertical, 16)
                .padding(.trailing, 8)
                .keyboardType(keyboardType)
                
        }
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
