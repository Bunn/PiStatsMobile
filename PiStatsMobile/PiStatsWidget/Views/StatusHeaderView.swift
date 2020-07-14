//
//  StatusHeaderView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 12/07/2020.
//

import SwiftUI


struct StatusHeaderView: View {
    @ObservedObject var dataProvider: PiholeDataProvider
    
    var body: some View {
        HStack {
            Label {
                Text(dataProvider.name)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
            } icon: {
                if dataProvider.hasErrorMessages {
                    Image(systemName: UIConstants.SystemImages.piholeStatusWarning)
                        .foregroundColor(UIConstants.Colors.statusWarning)
                } else if dataProvider.status == .allEnabled {
                    Image(systemName: UIConstants.SystemImages.piholeStatusOnline)
                        .foregroundColor(UIConstants.Colors.statusOnline)
                } else {
                    Image(systemName: UIConstants.SystemImages.piholeStatusOffline)
                        .foregroundColor(UIConstants.Colors.statusOffline)
                }
            }
            .font(.title2)
        }
    }
}


struct StatusHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StatusHeaderView(dataProvider: PiholeDataProvider.previewData())
    }
}
