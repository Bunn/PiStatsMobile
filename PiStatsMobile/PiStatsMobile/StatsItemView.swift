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
        HStack {
            
            VStack (alignment: .center){
                Text(type.title)
                    .foregroundColor(.white)
                    .font(.headline)
                Text("32,212")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .layoutPriority(1)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.horizontal, UIConstants.defaultPadding)
        .padding(.vertical, UIConstants.defaultPadding)
        .background(Color(type.colorName))
        .cornerRadius(UIConstants.defaultCornerRadius)
    }
    
}

struct StatsItemView_Previews: PreviewProvider {
    static var previews: some View {
        StatsItemView(type: .domainsOnBlockList)
    }
}
