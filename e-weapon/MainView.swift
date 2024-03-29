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
                    Label("txt_weapon", systemImage: "wrench.adjustable.fill")
                }
            
            AccessoryView()
                .tabItem {
                    Label("txt_accessories", systemImage: "puzzlepiece.extension.fill")
                }
            
            
            NavigationView{
                SettingsView()
            }
                .tabItem {
                    Label("txt_settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.primaryAccent)
        .onAppear {
            withAnimation {
                let currentThemeStyle = UserDefaults.standard.bool(forKey: "theme")
                (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = currentThemeStyle ? .dark : .light
            }
        }
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
