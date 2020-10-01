//
//  PiMonitorView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 01/10/2020.
//

import SwiftUI


struct PiMonitorView: View {
    var provider: PiholeDataProvider
    let imageSize: CGFloat = 15
    
    var body: some View {
        VStack (alignment:.leading) {
            VStack (alignment:.leading) {
                Label(title: {
                    Text(provider.name)
                }, icon: {
                    ViewUtils.shieldStatusImageForDataProvider(provider)
                    
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
            .font(Font.body.weight(.semibold))
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

struct PiMonitorView_Previews: PreviewProvider {
    static var previews: some View {
        PiMonitorView(provider: PiholeDataProvider.previewData())
    }
}
