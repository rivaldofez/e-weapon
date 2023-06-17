//
//  WeaponItemView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 15/06/23.
//

import SwiftUI

struct WeaponItemView: View {
    @Binding var weapon: Weapon

    func getImage(imageUrl: String) -> UIImage {
        let imagesDefaultURL = URL(fileURLWithPath: "/images/")
        let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
        let imageUrl = imagesFolderUrl.appendingPathComponent(imageUrl)
        
        do {
            let imageData = try Data(contentsOf: imageUrl)
            
            if let imageResult = UIImage(data: imageData){
                return imageResult
            }
        } catch {
            print("Not able to load image")
        }
        
        return UIImage(systemName: "exclamationmark.triangle.fill")!
        
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image(uiImage: getImage(imageUrl: weapon.imageUrl))
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(16)
                .padding(.trailing, 16)
                
            
            VStack(alignment: .leading, spacing: 8) {
                Text(weapon.name)
                    .font(.system(.title3).bold())
                    .foregroundColor(.primaryAccent)
                
                Text(Helper.formattedAmount(amount: weapon.price))
                    .font(.system(.body).bold())
                    .foregroundColor(.secondaryAccent)
                
                HStack {
                    HStack {
                        Image(systemName: "shippingbox.fill")
                            .font(.system(.callout))
                            .foregroundColor(.primaryGray)
                        Text("\(weapon.stock)")
                            .font(.system(.callout))
                            .foregroundColor(.primaryGray)
                        Spacer()
                    }
                    
                    HStack {
                        HStack {
                            Image(systemName: "info.square.fill")
                                .font(.system(.callout))
                                .foregroundColor(.primaryGray)
                            Text(weapon.status)
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
        WeaponItemView(weapon: .constant(Weapon(id: "", name: "Palu Gada", addedAt: Date(), price: 5000, stock: 100, imageUrl: "", location: "Gudang", status: "Save")))
    }
}
