//
//  MetricsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 26/07/2020.
//

import SwiftUI
import PiMonitor

struct MetricItem: Identifiable {
    let value: String
    let systemName: String
    let helpText: String
    let id: UUID = UUID()
}

struct MetricsView: View {
    @ObservedObject var dataProvider: PiholeDataProvider
    private let imageSize: CGFloat = 15

    func getMetricItems() -> [MetricItem] {
        return [
            MetricItem(value: dataProvider.temperature, systemName: UIConstants.SystemImages.metricTemperature, helpText: "Raspberry Pi temperature"),
            MetricItem(value: dataProvider.uptime, systemName: UIConstants.SystemImages.metricUptime, helpText: "Raspberry Pi uptime"),
            MetricItem(value: dataProvider.loadAverage, systemName: UIConstants.SystemImages.metricLoadAverage, helpText: "Raspberry Pi load average"),
            MetricItem(value: dataProvider.memoryUsage, systemName: UIConstants.SystemImages.metricMemoryUsage, helpText: "Raspberry Pi memory usage"),
        ]
    }

    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(getMetricItems()) { item in
                Label(title: {
                    Text(item.value)
                }, icon: {
                    Image(systemName: item.systemName)
                        .frame(width: imageSize, height: imageSize)
                })
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .font(.footnote)
                .help(item.helpText)
            }
        }
    }
}


struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView(dataProvider: PiholeDataProvider.previewData())
    }
}
