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
            Text("Test")
            HStack {
                Spacer()
                CountdownPickerViewRepresentable(duration: $timeInterval)
                    .background(Color(.red))
                Spacer()
            }
        }
    }
}

struct CustomDurationsView: View {
    var body: some View {
        List {
            TimePickerRow()
        }
    }
}

struct CustomDurationsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDurationsView()
    }
}
