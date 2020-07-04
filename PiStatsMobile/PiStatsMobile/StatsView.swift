//
//  StatsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI

struct StatsView: View {
    let layout = [
        GridItem(.adaptive(minimum: 300))
        ]
    var body: some View {
        
        VStack(spacing: 10) {
            HStack {
                StatsItemView(type: .totalQueries)
                StatsItemView(type: .queriesBlocked)
            }
            HStack {
                StatsItemView(type: .percentBlocked)
                StatsItemView(type: .domainsOnBlockList)
            }
        }
        
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
