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
    @State var status: String
    @State var image: UIImage

    var body: some View {
        HStack(alignment: .center) {
            Image(uiImage: image)
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(16)
                .padding(.trailing, 16)
                
            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.system(.title3).bold())
                    .foregroundColor(.primaryAccent)
                
                Text(price)
                    .font(.system(.body).bold())
                    .foregroundColor(.secondaryAccent)
                
                HStack {
                    HStack {
                        Image(systemName: "shippingbox.fill")
                            .font(.system(.callout))
                            .foregroundColor(.primaryGray)
                        Text(stock)
                            .font(.system(.callout))
                            .foregroundColor(.primaryGray)
                        Spacer()
                    }
                    
                    HStack {
                        HStack {
                            Image(systemName: "info.square.fill")
                                .font(.system(.callout))
                                .foregroundColor(.primaryGray)
                            Text(status)
                                .font(.system(.callout))
                                .foregroundColor(.primaryGray)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct WeaponItemView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponItemView(name: "Palu Gada", price: "Rp5.000.000", stock: "1000", status: "Bengkel", image: UIImage(systemName: "person")!)
    }
}
