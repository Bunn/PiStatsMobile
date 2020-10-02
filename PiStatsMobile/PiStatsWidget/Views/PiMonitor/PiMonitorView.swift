//
//  PiMonitorView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 01/10/2020.
//

import SwiftUI
import WidgetKit

fileprivate struct ListItem : Identifiable{
    let id = UUID()
    let text: String
    let systemImage: String
    let color: Color
}
struct PiMonitorStatsView: View {
    let imageSize: CGFloat = 15
    fileprivate let listItems: [ListItem]
    
    var body: some View {
        VStack (alignment:.leading, spacing: 6.0) {
            
            ForEach(listItems) { item in
                Label(title: {
                    Text(item.text)
                }, icon: {
                    Image(systemName: item.systemImage)
                        .frame(width: imageSize, height: imageSize)
                })
                .font(Font.body.weight(.medium))
                .minimumScaleFactor(0.80)
                .foregroundColor(item.color)
            }
        }
    }
}

struct PiMonitorView: View {
    var provider: PiholeDataProvider
    let imageSize: CGFloat = 15
    let shouldDisplayStats: Bool
    
    var body: some View {
        VStack (alignment:.leading) {
            PiMonitorStatusHeader(provider: provider)
            
            HStack {
                PiMonitorStatsView(listItems: getMetricListItems(provider))
                    .font(Font.body.weight(.semibold))
                    .minimumScaleFactor(0.89)
                
                if shouldDisplayStats {
                    Spacer()
                    
                    PiMonitorStatsView(listItems: getStatsListItems(provider))
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        ).padding()
        .font(.headline)
    }
    
    private func getMetricListItems(_ provider: PiholeDataProvider) -> [ListItem] {
        return [
            
            ListItem(text: provider.memoryUsage, systemImage: UIConstants.SystemImages.metricMemoryUsage, color: UIConstants.Colors.totalQueries),
            
            ListItem(text: provider.uptime, systemImage: UIConstants.SystemImages.metricUptime, color: UIConstants.Colors.queriesBlocked),

            ListItem(text: provider.temperature, systemImage: UIConstants.SystemImages.metricTemperature, color: UIConstants.Colors.domainsOnBlocklist),
            
            ListItem(text: provider.loadAverage, systemImage: UIConstants.SystemImages.metricLoadAverage, color: UIConstants.Colors.percentBlocked),
        ]
    }
    
    private func getStatsListItems(_ provider: PiholeDataProvider) -> [ListItem] {
        return [
            ListItem(text: provider.totalQueries, systemImage: UIConstants.SystemImages.totalQueries, color: UIConstants.Colors.totalQueries),
            
            ListItem(text: provider.queriesBlocked, systemImage: UIConstants.SystemImages.queriesBlocked, color: UIConstants.Colors.queriesBlocked),
            
            ListItem(text: provider.domainsOnBlocklist, systemImage: UIConstants.SystemImages.domainsOnBlockList, color: UIConstants.Colors.domainsOnBlocklist),
            
            ListItem(text: provider.percentBlocked, systemImage: UIConstants.SystemImages.percentBlocked, color: UIConstants.Colors.percentBlocked),
        ]
    }
}

struct PiMonitorView_Previews: PreviewProvider {
    static var previews: some View {
        PiMonitorView(provider: PiholeDataProvider.previewData(), shouldDisplayStats: true)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        PiMonitorView(provider: PiholeDataProvider.previewData(), shouldDisplayStats: false)
            .previewContext(WidgetPreviewContext(family: .systemSmall))


    }
}
