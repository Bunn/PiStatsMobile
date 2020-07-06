//
//  PiholeSetupView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 06/07/2020.
//

import SwiftUI

struct PiholeSetupView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var host: String = ""
    @State private var port: String = ""
    @State private var token: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Pi-hole")) {
                    TextField("Host", text: $host)
                    TextField("Port", text: $port)
                    TextField("Token", text: $token)
                }
             
            }.listStyle(InsetGroupedListStyle())
            
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
