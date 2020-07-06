//
//  StatsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI

struct StatsView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Geometry.defaultPadding) {
            HStack {
                Image(systemName: "checkmark.shield.fill")
                    .foregroundColor(Color("TotalQueries"))
                    // Image(systemName: "xmark.shield.fill")
                    //   .foregroundColor(Color("DomainsOnBlockList"))
                    .font(.title2)
                
                Text("192.168.1.143")
                    .foregroundColor(.primary)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            HStack {
                StatsItemView(type: .totalQueries)
                StatsItemView(type: .queriesBlocked)
            }
            HStack {
                StatsItemView(type: .percentBlocked)
                StatsItemView(type: .domainsOnBlockList)
            }
            Divider()
            Button(action: { }, label: {
                HStack (spacing: 0) {
                    Image(systemName: "pause") //play
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(UIConstants.Strings.disableButton)
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(UIConstants.Geometry.defaultCornerRadius)
            })
        }
        .padding()
        
        .background(Color(.secondarySystemBackground))
        .cornerRadius(UIConstants.Geometry.defaultCornerRadius)
        .shadow(radius: UIConstants.Geometry.shadowRadius)
        .padding()
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
