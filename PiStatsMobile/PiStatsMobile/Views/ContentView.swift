//
//  ContentView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 02/07/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                PiholeStatsList()
            }
            .tabItem {
                Image(systemName: "shield")
                Text("Pi-holes")
            }.tag(0)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text(UIConstants.Strings.settings)
            }.tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "pt_br"))
            ContentView()
                .preferredColorScheme(.dark)
        }
        
    }
}

