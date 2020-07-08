//
//  PiholeStatsList.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 05/07/2020.
//

import SwiftUI

struct PiholeStatsList: View {
    @State private var showingSetupView = false
    
    @EnvironmentObject private var piholeProviderListManager: PiholeDataProviderListManager

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                ForEach(piholeProviderListManager.providerList, id: \.id) { provider in
                    StatsView(dataProvider: provider)
                        .onTapGesture() {
                            showingSetupView = true
                        }
                }
                
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
                        .environmentObject(piholeProviderListManager)
                }
                .shadow(radius: UIConstants.Geometry.shadowRadius)
                .padding()
                if piholeProviderListManager.isEmpty {
                    Text("Tap here to add your first pi-hole")
                }
            }
        }.navigationTitle("Pi-holes")
        .onAppear {
            if piholeProviderListManager.isEmpty {
                showingSetupView = true
            }
        }
    }
}


struct PiholeStatsList_Previews: PreviewProvider {
    static var previews: some View {
        PiholeStatsList()
    }
}
