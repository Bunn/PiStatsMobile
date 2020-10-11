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
        _token = State(initialValue: pihole?.apiToken ?? "")
        if pihole?.port != nil {
            _port = State(initialValue: String(pihole!.port!))
        }
        if pihole?.piMonitorPort != nil {
            _piMonitorPort = State(initialValue: String(pihole!.piMonitorPort!))
        }
        _displayName = State(initialValue: pihole?.displayName ?? "")
        _isPiMonitorEnabled = State(initialValue: pihole?.hasPiMonitor ?? false)
    }
    
    @Environment(\.presentationMode) private var mode: Binding<PresentationMode>
    @State private var host: String = ""
    @State private var port: String = ""
    @State private var token: String = ""
    @State private var displayName: String = ""
    @State private var isShowingScanner = false
    @State private var piMonitorPort: String = ""
    @State private var isPiMonitorEnabled: Bool = false
    @State private var displayPiMonitorAlert = false
    @State private var httpType: Int = 0

    @EnvironmentObject private var piholeProviderListManager: PiholeDataProviderListManager
    @Environment(\.openURL) var openURL

    private let piMonitorURL = URL(string: "https://github.com/Bunn/pi_monitor")!
    private let imageWidthSize: CGFloat = 20
    
    var pihole: Pihole?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(UIConstants.Strings.settingsSectionPihole), footer: Text(UIConstants.Strings.piholeTokenFooterSection)) {
          
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupHost)
                            .frame(width: imageWidthSize)
                        TextField(UIConstants.Strings.piholeSetupHostPlaceholder, text: $host)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupDisplayName)
                            .frame(width: imageWidthSize)
                        TextField(UIConstants.Strings.piholeSetupDisplayName, text: $displayName)
                            .disableAutocorrection(true)
                    }
                    
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupPort)
                            .frame(width: imageWidthSize)
                        TextField(UIConstants.Strings.piholeSetupPortPlaceholder, text: $port)
                            .keyboardType(.numberPad)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    HStack {
                        Picker(selection: $httpType, label: Text("")) {
                            Text("HTTP").tag(0)
                            Text("HTTPS").tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupToken)
                            .frame(width: imageWidthSize)
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
                                        }).navigationBarTitle(Text(UIConstants.Strings.qrCodeScannerTitle), displayMode: .inline)
                                }
                            }
                    }
                }
                
                Section(header: Text(UIConstants.Strings.settingsSectionPiMonitor)) {
                    HStack {        
                        Toggle(isOn: $isPiMonitorEnabled.animation()) {
                            HStack {
                                Image(systemName: UIConstants.SystemImages.piholeSetupMonitor)
                                    .frame(width: imageWidthSize)
                                Text(UIConstants.Strings.piholeSetupEnablePiMonitor)
                                    .lineLimit(1)
                                
                                Image(systemName: UIConstants.SystemImages.piMonitorInfoButton)
                                    .frame(width: imageWidthSize)
                                    .foregroundColor(Color(.systemBlue))
                                    .onTapGesture {
                                        displayPiMonitorAlert.toggle()
                                    }.alert(isPresented: $displayPiMonitorAlert) {
                                        Alert(title: Text(UIConstants.Strings.piMonitorSetupAlertTitle), message: Text(UIConstants.Strings.piMonitorExplanation), primaryButton: .default(Text(UIConstants.Strings.piMonitorSetupAlertLearnMoreButton)) {
                                            openURL(piMonitorURL)
                                        }, secondaryButton: .cancel(Text(UIConstants.Strings.piMonitorSetupAlertOKButton)))
                                    }
                            }
                        }
                    }
                    
                    if isPiMonitorEnabled {
                        HStack {
                            Image(systemName: UIConstants.SystemImages.piholeSetupPort)
                                .frame(width: imageWidthSize)
                            TextField(UIConstants.Strings.piMonitorSetupPortPlaceholder, text: $piMonitorPort)
                                .keyboardType(.numberPad)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                    }
                }
                
                if pihole != nil {
                    Section(footer: deleteButton()) { }
                }
                
            }.listStyle(InsetGroupedListStyle())

            .navigationBarItems(leading:
                                    Button(UIConstants.Strings.cancelButton) {
                                        dismissView()
                                    }, trailing: Button(UIConstants.Strings.saveButton) {
                                        savePihole()
                                    })
            .navigationTitle(UIConstants.Strings.piholeSetupTitle)
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
                Label(UIConstants.Strings.deleteButton, systemImage: UIConstants.SystemImages.deleteButton)
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
        let address = port.isEmpty ? host : "\(host):\(port)"
        
        if let pihole = pihole {
            piholeToSave = pihole
            piholeToSave.address = address
        } else {
            piholeToSave = Pihole(address: address)
        }
        piholeToSave.hasPiMonitor = isPiMonitorEnabled
        piholeToSave.piMonitorPort = Int(piMonitorPort)
        piholeToSave.apiToken = token
        piholeToSave.displayName = displayName.isEmpty ? nil : displayName
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
            handleScannedString(data)
        case .failure(let error):
            print("Scanning failed \(error)")
        }
    }
    
    private func handleScannedString(_ value: String) {
        
        let decoder = JSONDecoder()
        
        guard let data = value.data(using: .utf8) else { return }
        do {
            let result = try decoder.decode([String: ScannedPihole].self, from: data)
            if let scannedPihole = result["pihole"] {
                self.token = scannedPihole.token ?? ""
                self.host = scannedPihole.host
                self.port = String(scannedPihole.port)

            }
        } catch {
            self.token = value
        }
    }
}


struct PiholeSetupView_Previews: PreviewProvider {
    static var previews: some View {
        PiholeSetupView()
    }
}
