//
//  MetricsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 26/07/2020.
//

import SwiftUI

struct MetricItem: Identifiable {
    let value: String
    let systemName: String
    let helpText: String
    let id: UUID = UUID()
}

struct MetricsView: View {
    let items: [MetricItem] = [
        MetricItem(value: "47.8º C", systemName: "thermometer", helpText: "Raspberry Pi temperature"),
        MetricItem(value: "21 hours", systemName: "power", helpText: "Raspberry Pi uptime"),
        MetricItem(value: "0.23, 0.2, 0.08", systemName: "cpu", helpText: "Raspberry Pi load average"),
        MetricItem(value: "4.4.51-v7+", systemName: "server.rack", helpText: "Raspberry Pi kernel version"),
    ]
    
    let imageSize: CGFloat = 10
    
    let columns = [
        /*
         Not a big fan of this 30, but to align the second column
         with the second column stats cards this is necessary.
         I'm sure there's a better way to solve this, but it will do for now
         */
        GridItem(.flexible(), spacing: 30),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(items) { item in
                Label(title: {
                    Text(item.value)
                }, icon: {
                    Image(systemName: item.systemName)
                        .frame(width: imageSize, height: imageSize)
                })
                .font(.footnote)
                .help(item.helpText)
            }
        }
        
        
    }
}


struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}
