//
//  StatsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI

struct StatsView: View {
    
    var body: some View {
        VStack(spacing: UIConstants.Geometry.defaultPadding) {
            HStack {
                StatsItemView(type: .totalQueries)
                StatsItemView(type: .queriesBlocked)
            }
            HStack {
                StatsItemView(type: .percentBlocked)
                StatsItemView(type: .domainsOnBlockList)
            }
        }.padding()
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
