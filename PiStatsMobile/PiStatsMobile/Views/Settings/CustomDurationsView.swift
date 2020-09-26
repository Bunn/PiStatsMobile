//
//  CustomDurationsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 20/09/2020.
//

import SwiftUI

private struct TimePickerRow: View {
    @State private var timeInterval: TimeInterval = 0
    
    var body: some View {
        Group{
            HStack {
                Spacer()
                CountdownPickerViewRepresentable(duration: $timeInterval)
                Spacer()
            }
        }
    }
}

fileprivate struct DisableTimeItem: Identifiable {
    let id = UUID()
    @State var timeInterval: TimeInterval = 0
    @State var selected = false
    @State var title: String
}

struct CustomDurationsView: View {
    @State private var countdownPickerVisible = false
    private let items = [DisableTimeItem(title: "12"), DisableTimeItem(title: "1211"), DisableTimeItem(title: "1442")]
    
    var body: some View {
        List {
            ForEach(items) { item in
                
                Button(action: {
                    withAnimation {
                        item.selected.toggle()
                    }
                }, label: {
                    Text(item.title)
                        .foregroundColor(.primary)
                })
                
                if item.selected {
                    TimePickerRow()
                }
            }
            
        }.navigationBarTitle("Disable Time", displayMode: .inline)
        
    }
}

struct CustomDurationsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDurationsView()
    }
}
