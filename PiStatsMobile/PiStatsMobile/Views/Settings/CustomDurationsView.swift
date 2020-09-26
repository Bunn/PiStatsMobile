//
//  CustomDurationsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 20/09/2020.
//

import SwiftUI

private struct TimePickerRow: View {
    @State private var timeInterval: TimeInterval = 0
    @State private var birthDate = Date()

    var body: some View {
        Group{
            HStack {
                Spacer()
//                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) { }
//                .datePickerStyle(WheelDatePickerStyle())
                CountdownPickerViewRepresentable(duration: $timeInterval)

                Spacer()
            }
        }
    }
}


struct CustomDurationsView: View {
    let disableDurationManager: DisableDurationManager
    @EnvironmentObject private var userPreferences: UserPreferences
    @State private var countdownPickerVisible = false
    @State private var selectedItems = Set<DisableTimeItem>()
    
    
    var body: some View {
        List {
            ForEach(disableDurationManager.items.indices, id: \.self) { index in
                
                Button(action: {
                    withAnimation(.spring()) {
                        if selectedItems.contains(disableDurationManager.items[index]) {
                            selectedItems.remove(disableDurationManager.items[index])
                        } else {
                            selectedItems.insert(disableDurationManager.items[index])
                        }
                    }
                }, label: {
                    Text(disableDurationManager.items[index].title)
                        .foregroundColor(.primary)
                }) .transition(.move(edge: .leading))
                
                if selectedItems.contains(disableDurationManager.items[index]) {
                    TimePickerRow()
                        .transition(.move(edge: .leading))
                }
                
            } .transition(.move(edge: .leading))

        } .transition(.move(edge: .leading))

        .navigationBarTitle("Disable Time", displayMode: .inline)
        
    }
}

struct CustomDurationsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDurationsView(disableDurationManager: DisableDurationManager(userPreferences: UserPreferences()))
    }
}
