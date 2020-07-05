//
//  PiholeStatsList.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 05/07/2020.
//

import SwiftUI

struct PiholeStatsList: View {
    var body: some View {
        ZStack {
            UIConstants.Colors.background
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                StatsView()
                
                Button(action: { }, label: {
                    ZStack {
                        Circle()
                            .frame(width: UIConstants.Geometry.addPiholeButtonHeight, height: UIConstants.Geometry.addPiholeButtonHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        
                    }
                })
                .shadow(radius: UIConstants.Geometry.shadowRadius)
                .padding()
                
            }
        }.navigationTitle("Pi-holes")
    }
}


struct PiholeStatsList_Previews: PreviewProvider {
    static var previews: some View {
        PiholeStatsList()
    }
}
