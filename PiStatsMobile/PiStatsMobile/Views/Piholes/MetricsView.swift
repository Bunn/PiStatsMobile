//
//  MetricsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 26/07/2020.
//

import SwiftUI

struct MetricsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            Label("47.8º C", systemImage: "thermometer")
                .help("Raspberry Pi temperature")
            Label("21 hours", systemImage: "power")
                .help("Raspberry Pi uptime")
            
        }
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}
