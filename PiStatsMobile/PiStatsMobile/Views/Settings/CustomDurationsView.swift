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
    @StateObject var disableDurationManager = DisableDurationManager(userPreferences: UserPreferences.shared)
    @State private var selectedItems = Set<DisableTimeItem>()

    var body: some View {
        Group {
            if disableDurationManager.items.count == 0 {
                VStack {
                    Text("Tap here to add a custom disable time")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                Button(action: {
                   addNewDuration()
                }, label: {
                    ZStack {
                        Circle()
                            .frame(width: UIConstants.Geometry.addPiholeButtonHeight, height: UIConstants.Geometry.addPiholeButtonHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Image(systemName: UIConstants.SystemImages.addPiholeButton)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                })
                .shadow(radius: UIConstants.Geometry.shadowRadius)
                .padding()
                }
            } else {
                List {
                ForEach(disableDurationManager.items, id: \.self) { item in
                    Button(action: {
                        withAnimation {
                            if selectedItems.contains(item) {
                                selectedItems.remove(item)
                            } else {
                                selectedItems.insert(item)
                            }
                        }
                    }, label: {
                        Text(item.title)
                            .foregroundColor(.primary)
                    })
                    /*
                     This is required because once you use ForEach you can't use bindings anymore.
                     One strategy is to use indices when looping, but when I do that the animations get really weird (more than already is)
                     specially on delete animations
                     */
                    if selectedItems.contains(item) {
                        TimePickerRow(timeInterval: Binding(
                            get: { item.timeInterval },
                            set: { item.timeInterval = $0 } ))
                    }
                }.onDelete(perform: delete)
            }
            
        
        }
        }
        .navigationBarTitle("Disable Time", displayMode: .inline)
        .navigationBarItems(trailing:
                                    Button(action: {
                                        withAnimation {
                                            addNewDuration()
                                        }
                                    }) {
                                        Image(systemName: "plus")
                                    }
        )
    }
    
    private func addNewDuration() {
        disableDurationManager.addNewItem()
    }
    
    func delete(at offsets: IndexSet) {
        offsets.map { disableDurationManager.items[$0] }.forEach { itemToDelete in
            selectedItems.remove(itemToDelete)
        }
        disableDurationManager.delete(at: offsets)
    }
}

struct CustomDurationsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDurationsView(disableDurationManager: DisableDurationManager(userPreferences: UserPreferences()))
    }
}
