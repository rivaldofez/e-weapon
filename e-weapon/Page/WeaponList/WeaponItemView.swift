//
//  WeaponItemView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 15/06/23.
//

import SwiftUI

struct WeaponItemView: View {
    @State var name: String
    @State var price: String
    @State var stock: String
    @State var image: UIImage
    
    var body: some View {
        HStack(alignment: .center) {
            Image(uiImage: image)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.system(.title3).bold())
                
                HStack {
                    Text(price)
                        .font(.system(.body))
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "shippingbox.fill")
                        Text(stock)
                        Spacer()
                    }
                    .padding(.trailing, 8)
                    .frame(width: 90)
                }
                
                
            }
        }
    }
}

struct WeaponItemView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponItemView(name: "Palu Gada", price: "Rp5.000.000", stock: "1000", image: UIImage(systemName: "person")!)
    }
}
