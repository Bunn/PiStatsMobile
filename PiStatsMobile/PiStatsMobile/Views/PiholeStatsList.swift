//
//  PiholeStatsList.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 05/07/2020.
//

import SwiftUI

struct PiholeStatsList: View {
    @State var showingSetupView = false

    var body: some View {
        ZStack {
            UIConstants.Colors.background
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                StatsView()
                
                Button(action: {
                    showingSetupView = true
                }, label: {
                    ZStack {
                        Circle()
                            .frame(width: UIConstants.Geometry.addPiholeButtonHeight, height: UIConstants.Geometry.addPiholeButtonHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                })
                .sheet(isPresented: $showingSetupView) {
                    PiholeSetupView()
                }
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
