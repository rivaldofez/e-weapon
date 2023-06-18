//
//  SettingsViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 18/06/23.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @Published var currentThemeStyle: Bool = true
    
    func setThemeStyle(isDark: Bool){
        UserDefaults.standard.set(isDark, forKey: "theme")
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = isDark ? .dark : .light
        currentThemeStyle = isDark
        
    }
    
    func getThemeStyle() {
        currentThemeStyle = UserDefaults.standard.bool(forKey: "theme")
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = currentThemeStyle ? .dark : .light
    }
}
