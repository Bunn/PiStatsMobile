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
                Section(header: Text("Pi-hole"), footer: Text(UIConstants.Strings.piholeTokenFooterSection)) {
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupHost)
                        TextField(UIConstants.Strings.piholeSetupHostPlaceholder, text: $host)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupPort)
                        TextField(UIConstants.Strings.piholeSetupPortPlaceholder, text: $port)
                            .keyboardType(.numberPad)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupToken)
                        SecureField(UIConstants.Strings.piholeSetupTokenPlaceholder, text: $token)
                        
                        Button(action: {
                            print("a")
                        }, label: {
                            Image(systemName: UIConstants.SystemImages.piholeSetupTokenQRCode)
                        })
                    }
                }
                
            }.listStyle(InsetGroupedListStyle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
            
            .navigationBarItems(leading:
                                    Button(UIConstants.Strings.cancelButton) {
                                        self.mode.wrappedValue.dismiss()
                                        
                                    }, trailing: Button(UIConstants.Strings.saveButton) {
                                        self.mode.wrappedValue.dismiss()
                                        
                                    } )
            .navigationTitle("Pi-hole Setup")
        }
    }
}


struct PiholeSetupView_Previews: PreviewProvider {
    static var previews: some View {
        PiholeSetupView()
    }
}
