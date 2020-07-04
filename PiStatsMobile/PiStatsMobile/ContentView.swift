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
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                StatsView()
                    .background(Color("CardColor"))
                    .cornerRadius(UIConstants.defaultCornerRadius)
                    .shadow(radius: 5)
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
            
    }
}
