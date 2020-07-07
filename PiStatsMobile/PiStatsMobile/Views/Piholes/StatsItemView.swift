//
//  StatsItemView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI

struct StatsItemView: View {
    let type: StatsItemType
    
    var body: some View {
        
        VStack (alignment: .leading){
            Text(type.title)
                .foregroundColor(.white)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Label("32,12345", systemImage: type.imageName)
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
 
        .padding(.horizontal, UIConstants.Geometry.defaultPadding)
        .padding(.vertical, UIConstants.Geometry.defaultPadding)
        .background(Color(type.colorName))
        .cornerRadius(UIConstants.Geometry.defaultCornerRadius)
    }
}

struct StatsItemView_Previews: PreviewProvider {
    static var previews: some View {
        StatsItemView(type: .domainsOnBlockList)
    }
}
