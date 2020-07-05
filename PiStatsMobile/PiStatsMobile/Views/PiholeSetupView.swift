//
//  PiholeSetupView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 06/07/2020.
//

import SwiftUI

struct PiholeSetupView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            Form {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                
            }
            .navigationBarItems(leading:
                                    Button("Cancel") {
                                        self.mode.wrappedValue.dismiss() } )
            .navigationTitle("Pi-hole Setup")
        }
    }
}

struct PiholeSetupView_Previews: PreviewProvider {
    static var previews: some View {
        PiholeSetupView()
    }
}
