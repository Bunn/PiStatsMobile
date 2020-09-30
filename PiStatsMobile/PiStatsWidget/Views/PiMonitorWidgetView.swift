//
//  PiMonitorWidgetView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 29/09/2020.
//

import SwiftUI
import WidgetKit

struct PiMonitorView: View {
    var provider: PiholeDataProvider
    let imageSize: CGFloat = 15
    
    var body: some View {
        VStack (alignment:.leading) {
            VStack (alignment:.leading) {
                Label(title: {
                    Text(provider.name)
                }, icon: {
                    Image(systemName: UIConstants.SystemImages.piholeStatusWarning)
                        .frame(width: imageSize, height: imageSize)
                        .foregroundColor(UIConstants.Colors.statusOnline)
                    
                })
                .font(Font.headline.weight(.bold))
                Divider()
                Spacer()
            }
            
            VStack (alignment:.leading, spacing: 6.0) {
                
                Label(title: {
                    Text(provider.temperature)
                }, icon: {
                    Image(systemName: UIConstants.SystemImages.metricTemperature)
                        .frame(width: imageSize, height: imageSize)
                })
                .foregroundColor(UIConstants.Colors.domainsOnBlocklist)
                Label(title: {
                    Text(provider.uptime)
                }, icon: {
                    Image(systemName: UIConstants.SystemImages.metricUptime)
                        .frame(width: imageSize, height: imageSize)
                    
                })
                .foregroundColor(UIConstants.Colors.queriesBlocked)
                
                Label(title: {
                    Text(provider.memoryUsage)
                }, icon: {
                    Image(systemName: UIConstants.SystemImages.metricMemoryUsage)
                        .frame(width: imageSize, height: imageSize)
                })
                .foregroundColor(UIConstants.Colors.totalQueries)
                                
                Label(title: {
                    Text(provider.loadAverage)
                }, icon: {
                    Image(systemName: UIConstants.SystemImages.metricLoadAverage)
                        .frame(width: imageSize, height: imageSize)
                })
                .foregroundColor(UIConstants.Colors.percentBlocked)
            }
            .font(Font.body.weight(.bold))
            .minimumScaleFactor(0.89)

            
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        ).padding()
        .font(.headline)
    }
}

struct PiMonitorWidgetView: View {
    var entry: PiholeEntry
    
    var body: some View {
        ZStack {
            UIConstants.Colors.piMonitorWidgetBackground
            if entry.piholeDataProvider.piholes.count == 0 {
                PiMonitorView(provider: PiholeDataProvider.previewData() ).redacted(reason: .placeholder)
            } else {
                PiMonitorView(provider: entry.piholeDataProvider)
            }
        }
    }
}

struct PiMonitorWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        PiMonitorWidgetView(entry: PiholeEntry.init(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemMedium))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        PiMonitorWidgetView(entry: PiholeEntry.init(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemMedium))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
