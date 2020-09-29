//
//  PiMonitorWidgetView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 29/09/2020.
//

import SwiftUI
import WidgetKit

struct PiMonitorWidgetView: View {
    var entry: PiholeEntry
    let imageSize: CGFloat = 15
    
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
            
            VStack (alignment:.leading) {
                VStack (alignment:.leading) {
                    Label(title: {
                        Text("192.123.22.11")
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
                        Text("47 ºC")
                    }, icon: {
                        Image(systemName: UIConstants.SystemImages.metricTemperature)
                            .frame(width: imageSize, height: imageSize)
                    })
                    .foregroundColor(UIConstants.Colors.domainsOnBlocklist)
                    Label(title: {
                        Text("43d 9h 2m")
                    }, icon: {
                        Image(systemName: UIConstants.SystemImages.metricUptime)
                            .frame(width: imageSize, height: imageSize)
                        
                    })
                    .foregroundColor(UIConstants.Colors.queriesBlocked)
                    
                    Label(title: {
                        Text("0.0, 0.01, 0.4")
                    }, icon: {
                        Image(systemName: UIConstants.SystemImages.metricLoadAverage)
                            .frame(width: imageSize, height: imageSize)
                    })
                    .foregroundColor(UIConstants.Colors.percentBlocked)
                    
                    Label(title: {
                        Text("13,32%")
                    }, icon: {
                        Image(systemName: UIConstants.SystemImages.metricMemoryUsage)
                            .frame(width: imageSize, height: imageSize)
                    })
                    .foregroundColor(UIConstants.Colors.totalQueries)
                }
                .font(Font.headline.weight(.bold))
                
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            ).padding()
            .font(.headline)
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
