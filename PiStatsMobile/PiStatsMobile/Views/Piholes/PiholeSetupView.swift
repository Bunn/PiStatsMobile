//
//  PiholeSetupView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 06/07/2020.
//

import SwiftUI

enum SecureTag: Int {
    case unsecure
    case secure
}

fileprivate class SetupViewModel: ObservableObject {
    let piMonitorURL = URL(string: "https://github.com/Bunn/pi_monitor")!
    @EnvironmentObject private var piholeProviderListManager: PiholeDataProviderListManager

    @Published var pihole: Pihole?
    @Published var host: String = ""
    @Published var port: String = ""
    @Published var token: String = ""
    @Published var displayName: String = ""
    @Published var isShowingScanner = false
    @Published var piMonitorPort: String = ""
    @Published var isPiMonitorEnabled: Bool = false
    @Published var displayPiMonitorAlert = false
    @Published var httpType: SecureTag = .unsecure
    
    init(pihole: Pihole? = nil) {
        self.pihole = pihole
       
        if let pihole = pihole {
            host = pihole.host
            token = pihole.apiToken
            httpType = pihole.secure ? .secure : .unsecure
            isPiMonitorEnabled = pihole.hasPiMonitor
           
            if let piholePort = pihole.port {
                port = String(piholePort)
            }
            
            if let piholeMonitorPort = pihole.piMonitorPort {
                piMonitorPort = String(piholeMonitorPort)
            }
            
        } else {
            host = ""
            token = ""
            httpType = .unsecure
            isPiMonitorEnabled = false
        }

        displayName = pihole?.displayName ?? ""
    }
    
    func savePihole() {
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
        piholeToSave.secure = httpType == .secure
        piholeToSave.save()
    }
    
    func deletePihole() {
        if let pihole = pihole {
            pihole.delete()
        }
    }
}

struct PiholeSetupView: View {
    
    init(pihole: Pihole? = nil) {
        _viewModel = StateObject(wrappedValue: SetupViewModel(pihole: pihole))
    }
    
    @StateObject private var viewModel: SetupViewModel
    @EnvironmentObject private var piholeProviderListManager: PiholeDataProviderListManager
    
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) private var mode: Binding<PresentationMode>

    private let imageWidthSize: CGFloat = 20
        
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(UIConstants.Strings.settingsSectionPihole), footer: Text(UIConstants.Strings.piholeTokenFooterSection)) {
          
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupHost)
                            .frame(width: imageWidthSize)
                        TextField(UIConstants.Strings.piholeSetupHostPlaceholder, text: $viewModel.host)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupDisplayName)
                            .frame(width: imageWidthSize)
                        TextField(UIConstants.Strings.piholeSetupDisplayName, text: $viewModel.displayName)
                            .disableAutocorrection(true)
                    }
                    
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupPort)
                            .frame(width: imageWidthSize)
                        TextField(UIConstants.Strings.piholeSetupPortPlaceholder, text: $viewModel.port)
                            .keyboardType(.numberPad)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    HStack {
                        Picker(selection: $viewModel.httpType, label: Text("")) {
                            Text(UIConstants.Strings.Preferences.protocolHTTP).tag(SecureTag.unsecure)
                            Text(UIConstants.Strings.Preferences.protocolHTTPS).tag(SecureTag.secure)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    HStack {
                        Image(systemName: UIConstants.SystemImages.piholeSetupToken)
                            .frame(width: imageWidthSize)
                        SecureField(UIConstants.Strings.piholeSetupTokenPlaceholder, text: $viewModel.token)
                        
                        Image(systemName: UIConstants.SystemImages.piholeSetupTokenQRCode)
                            .foregroundColor(Color(.systemBlue))
                            .onTapGesture {
                                viewModel.isShowingScanner = true
                            }.sheet(isPresented: $viewModel.isShowingScanner) {
                                NavigationView {
                                    CodeScannerView(codeTypes: [.qr], simulatedData: "abcd", completion: handleScan)
                                        .navigationBarItems(leading:  Button(UIConstants.Strings.cancelButton) {
                                            viewModel.isShowingScanner = false
                                        }).navigationBarTitle(Text(UIConstants.Strings.qrCodeScannerTitle), displayMode: .inline)
                                }
                            }
                    }
                }
                
                Section(header: Text(UIConstants.Strings.settingsSectionPiMonitor)) {
                    HStack {        
                        Toggle(isOn: $viewModel.isPiMonitorEnabled.animation()) {
                            HStack {
                                Image(systemName: UIConstants.SystemImages.piholeSetupMonitor)
                                    .frame(width: imageWidthSize)
                                Text(UIConstants.Strings.piholeSetupEnablePiMonitor)
                                    .lineLimit(1)
                                
                                Image(systemName: UIConstants.SystemImages.piMonitorInfoButton)
                                    .frame(width: imageWidthSize)
                                    .foregroundColor(Color(.systemBlue))
                                    .onTapGesture {
                                        viewModel.displayPiMonitorAlert.toggle()
                                    }.alert(isPresented: $viewModel.displayPiMonitorAlert) {
                                        Alert(title: Text(UIConstants.Strings.piMonitorSetupAlertTitle), message: Text(UIConstants.Strings.piMonitorExplanation), primaryButton: .default(Text(UIConstants.Strings.piMonitorSetupAlertLearnMoreButton)) {
                                            openURL(viewModel.piMonitorURL)
                                        }, secondaryButton: .cancel(Text(UIConstants.Strings.piMonitorSetupAlertOKButton)))
                                    }
                            }
                        }
                    }
                    
                    if viewModel.isPiMonitorEnabled {
                        HStack {
                            Image(systemName: UIConstants.SystemImages.piholeSetupPort)
                                .frame(width: imageWidthSize)
                            TextField(UIConstants.Strings.piMonitorSetupPortPlaceholder, text: $viewModel.piMonitorPort)
                                .keyboardType(.numberPad)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                    }
                }
                
                if viewModel.pihole != nil {
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
        mode.wrappedValue.dismiss()
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
        viewModel.savePihole()
        piholeProviderListManager.updateList()
        dismissView()
    }
    
    private func deletePihole() {
        viewModel.deletePihole()
        piholeProviderListManager.updateList()
        dismissView()
    }
    
    private func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.viewModel.isShowingScanner = false
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
                viewModel.token = scannedPihole.token ?? ""
                viewModel.host = scannedPihole.host
                viewModel.port = String(scannedPihole.port)
            }
        } catch {
            viewModel.token = value
        }
    }
}


struct PiholeSetupView_Previews: PreviewProvider {
    static var previews: some View {
        PiholeSetupView()
    }
}
