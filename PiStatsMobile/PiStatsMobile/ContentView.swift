//
//  ContentView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 02/07/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack {
            UIConstants.Colors.background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                StatsView()
                    .cornerRadius(UIConstants.Geometry.defaultCornerRadius)
                    .shadow(radius: 5)
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
            ContentView()
                .preferredColorScheme(.dark)
        }
        
    }
}
