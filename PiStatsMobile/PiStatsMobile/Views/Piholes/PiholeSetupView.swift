//
//  PiholeSetupView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 06/07/2020.
//

import SwiftUI

struct PiholeSetupView: View {
    
    init(pihole: Pihole? = nil) {
        self.pihole = pihole
        _host = State(initialValue: pihole?.host ?? "")
        print("aa \(pihole?.host)")
        _port = State(initialValue: pihole?.address ?? "")

    }
    
    @Environment(\.presentationMode) private var mode: Binding<PresentationMode>
    @State private var host: String = ""
    @State private var port: String = ""
    @State private var token: String = ""
    @State private var isShowingScanner = false
    @EnvironmentObject private var piholeProviderListManager: PiholeDataProviderListManager
    var pihole: Pihole?
    
    
    
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
                        
                        Image(systemName: UIConstants.SystemImages.piholeSetupTokenQRCode)
                            .foregroundColor(Color(.systemBlue))
                            .onTapGesture {
                                isShowingScanner = true
                            }.sheet(isPresented: $isShowingScanner) {
                                NavigationView {
                                    CodeScannerView(codeTypes: [.qr], simulatedData: "abcd", completion: self.handleScan)
                                        .navigationBarItems(leading:  Button(UIConstants.Strings.cancelButton) {
                                            isShowingScanner = false
                                        }).navigationBarTitle(Text("Scanner"), displayMode: .inline)
                                }
                            }
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
                                        savePihole()
                                    })
            .navigationTitle("Pi-hole Setup")
        }
    }
    
    private func savePihole() {
        let pihole = Pihole(address: host)
        pihole.save()
        piholeProviderListManager.add(pihole)
    }
    
    private func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let data):
            self.token = data
        case .failure(let error):
            print("Scanning failed \(error)")
        }
    }
}


struct PiholeSetupView_Previews: PreviewProvider {
    static var previews: some View {
        PiholeSetupView()
    }
}
