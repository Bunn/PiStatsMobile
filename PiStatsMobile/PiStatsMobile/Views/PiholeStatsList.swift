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
                StatsView()
                StatsView()
                StatsView()
                
            }
        }.navigationTitle("Pi-holes")
    }
}


struct PiholeStatsList_Previews: PreviewProvider {
    static var previews: some View {
        PiholeStatsList()
    }
}
