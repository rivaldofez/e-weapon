//
//  CustomSegmentedControl.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 13/06/23.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedItem: String
    @State var cornerRadius: CGFloat = 8
    var items: [String]
    
    var paddingSize: CGFloat = 0
    var heightSize: CGFloat = 45
    
    var selectedBackgroundColor: Color = .primaryAccent
    var selectedTextColor: Color = .primaryButtonLabel
    
    var textColor: Color = .primaryLabel
    var backgroundColor: Color = .clear
    
    var strokeColor: Color = .primaryGray
    
    
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id:\.self) { item in
                ZStack {
                    Rectangle()
                        .fill(.clear)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(selectedBackgroundColor)
                        .opacity(item == selectedItem ? 1 : 0.01)
                        .onTapGesture {
                            withAnimation(.linear) {
                                selectedItem = item
                            }
                        }
                }
                .overlay(
                    Text(item)
                        .foregroundColor(item == selectedItem ? selectedTextColor : textColor)
                        .font(.system(.body).bold())
                    
                )
            }
        }
        .padding(paddingSize)
        .background(Color.white)
        .frame(height: heightSize)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(strokeColor, lineWidth: 1)
        }
    }
}

struct CustomSegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedControl(selectedItem: .constant("Used"), items: ["Saved", "Used"])
    }
}
