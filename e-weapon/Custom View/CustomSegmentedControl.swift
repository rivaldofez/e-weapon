//
//  CustomSegmentedControl.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 13/06/23.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    @State var cornerRadius: CGFloat = 8
    var options: [String]
    var selectedBackgroundColor = Color.gray
    var selectedTextColor = Color.white
    
    var textColor = Color.black
    var backgroundColor = Color.clear
    
    var borderColor = Color.gray.opacity(0.5)
    
    var paddingSize: CGFloat = 0
    var heightSize: CGFloat = 45
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(.clear)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(selectedBackgroundColor)
                        .opacity(preselectedIndex == index ? 1 : 0.01)
                        .onTapGesture {
                            withAnimation(.linear) {
                                preselectedIndex = index
                            }
                        }
                }
                .overlay(
                    Text(options[index])
                        .foregroundColor(preselectedIndex == index ? selectedTextColor : textColor)
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
                .stroke(borderColor, lineWidth: 2)
        }
    }
}

struct CustomSegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedControl(preselectedIndex: .constant(0), options: ["Expense", "Income"])
    }
}
