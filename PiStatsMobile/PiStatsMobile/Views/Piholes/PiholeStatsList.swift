//
//  PiholeStatsList.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 05/07/2020.
//

import SwiftUI

struct PiholeStatsList: View {
    @State private var showingSetupView = false
    @State private var hasAtLeastOnePihole = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                
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
                if hasAtLeastOnePihole == false {
                    Text("Tap here to add your first pi-hole")
                }
            }
        }.navigationTitle("Pi-holes")
        .onAppear {
            showingSetupView = true
        }
    }
}


struct PiholeStatsList_Previews: PreviewProvider {
    static var previews: some View {
        PiholeStatsList()
    }
}
