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
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Image(systemName: type.imageName)
                    .foregroundColor(.white)
                    .font(.subheadline)
                Text("32,212")
                    .foregroundColor(.white)
                    .font(.body)
                    .fontWeight(.bold)
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
