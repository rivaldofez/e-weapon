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
                    Label("Weapon", systemImage: "person")
                }
            
            AccessoriesView()
                .tabItem {
                    Label("Accessories", systemImage: "person")
                }
            
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "person")
                }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
