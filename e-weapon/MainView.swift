//
//  MainView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI


struct MainView: View {
    var body: some View {
        TabView {
            WeaponView()
                .tabItem {
                    Label("Weapon", systemImage: "wrench.adjustable.fill")
                }
            
            AccessoriesView()
                .tabItem {
                    Label("Accessories", systemImage: "puzzlepiece.extension.fill")
                }
            
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.primaryAccent)
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
