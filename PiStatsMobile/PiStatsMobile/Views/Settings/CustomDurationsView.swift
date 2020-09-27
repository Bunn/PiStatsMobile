//
//  CustomDurationsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 20/09/2020.
//

import SwiftUI

private struct TimePickerRow: View {
    @Binding var timeInterval: TimeInterval
    
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

struct CustomDurationsView: View {
    @StateObject var disableDurationManager = DisableDurationManager(userPreferences: UserPreferences())
    @State private var selectedItems = Set<DisableTimeItem>()
    
    var body: some View {
        List {
            ForEach(disableDurationManager.items.indices, id: \.self) { index in
                
                Button(action: {
                    withAnimation {
                        if selectedItems.contains(disableDurationManager.items[index]) {
                            selectedItems.remove(disableDurationManager.items[index])
                        } else {
                            selectedItems.insert(disableDurationManager.items[index])
                        }
                    }
                }, label: {
                    Text(disableDurationManager.items[index].title)
                        .foregroundColor(.primary)
                })
                
                if selectedItems.contains(disableDurationManager.items[index]) {
                    TimePickerRow(timeInterval: $disableDurationManager.items[index].timeInterval)
                    
                }
            }.onDelete(perform: delete)
            
        }
        .navigationBarTitle("Disable Time", displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    addNewDuration()
                                }) {
                                    Image(systemName: "plus")
                                }
        )
    }
    
    private func addNewDuration() {
        disableDurationManager.addNewItem()
    }
    
    func delete(at offsets: IndexSet) {
        disableDurationManager.delete(at: offsets)
    }
}

struct CustomDurationsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDurationsView(disableDurationManager: DisableDurationManager(userPreferences: UserPreferences()))
    }
}
