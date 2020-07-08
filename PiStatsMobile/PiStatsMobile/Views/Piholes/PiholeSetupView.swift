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
                
                if pihole != nil {
                    Section(footer: deleteButton()) { }
                }
                
            }.listStyle(InsetGroupedListStyle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
            .navigationBarItems(leading:
                                    Button(UIConstants.Strings.cancelButton) {
                                        dismissView()
                                    }, trailing: Button(UIConstants.Strings.saveButton) {
                                        savePihole()
                                    })
            .navigationTitle("Pi-hole Setup")
        }
    }
    
    private func dismissView() {
        self.mode.wrappedValue.dismiss()
    }
    
    private func deleteButton() -> some View {
        Button(action: {
            deletePihole()
        }, label: {
            HStack (spacing: 0) {
                Label("Delete", systemImage: "minus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color(.systemRed))
            .cornerRadius(UIConstants.Geometry.defaultCornerRadius)
        })
    }
    
    private func savePihole() {
        var piholeToSave: Pihole
        
        if let pihole = pihole {
            piholeToSave = pihole
        } else {
            piholeToSave = Pihole(address: host)
        }
        piholeToSave.apiToken = token
        piholeToSave.save()
        piholeProviderListManager.updateList()
        dismissView()
    }
    
    private func deletePihole() {
        if let pihole = pihole {
            pihole.delete()
            piholeProviderListManager.updateList()
        }
        dismissView()
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
