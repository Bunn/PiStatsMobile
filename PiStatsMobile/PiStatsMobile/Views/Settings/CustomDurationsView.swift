//
//  CustomDurationsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 20/09/2020.
//

import SwiftUI

private struct TimePickerRow: View {
    var body: some View {
        VStack {
            Text("30min")
            DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
                .datePickerStyle(WheelDatePickerStyle())
        }

    }
}

struct CustomDurationsView: View {
    var body: some View {
        List {

TimePickerRow()
            TimePickerRow()
        }
    }
}

struct CustomDurationsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDurationsView()
    }
}
