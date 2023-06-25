//
//  SettingsView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI


struct SettingsView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading, spacing: 0) {
                Text("txt_theme_preference")
                    .font(.system(.body).bold())
                    .padding()
                    .foregroundColor(.primaryAccent)
                
                Divider()
                
                Button {
                    withAnimation {
                        viewModel.setThemeStyle(isDark: false)
                    }
                } label: {
                    HStack {
                        Image(systemName: "sun.max")
                            .resizable()
                            .frame(width:
                                    30, height: 30)
                            .foregroundColor(.primaryLabel)
                        Text("txt_light_mode")
                            .font(.system(.body).weight(.medium))
                            .padding(.leading, 16)
                            .foregroundColor(.primaryLabel)
                        
                        Spacer()
                        
                        
                        if(!viewModel.currentThemeStyle){
                            Image(systemName: "checkmark")
                                .font(.system(.title3).weight(.bold))
                                .foregroundColor(.primaryAccent)
                                .padding(.horizontal)
                        }
                        
                        
                    }.padding()
                }
                
                Divider()
                
                Button {
                    withAnimation {
                        viewModel.setThemeStyle(isDark: true)
                    }
                } label: {
                    HStack {
                        Image(systemName: "moon")
                            .resizable()
                            .frame(width:
                                    30, height: 30)
                            .foregroundColor(.primaryLabel)
                        Text("txt_dark_mode")
                            .font(.system(.body).weight(.medium))
                            .padding(.leading, 16)
                            .foregroundColor(.primaryLabel)
                        
                        Spacer()
                        
                        
                        if(viewModel.currentThemeStyle){
                            Image(systemName: "checkmark")
                                .font(.system(.title3).weight(.bold))
                                .foregroundColor(.primaryAccent)
                                .padding(.horizontal)
                        }
                        
                    }
                    .padding()
                }
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.primaryGray.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
            .padding(.top, 16)
            
            Spacer()
        }
        .onAppear{
            viewModel.getThemeStyle()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Text("txt_settings")
                    .font(.system(.title).bold())
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
