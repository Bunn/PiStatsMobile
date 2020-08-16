//
//  PiholeStatsList.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 05/07/2020.
//

import SwiftUI
import WidgetKit

final class StatsListConfig: ObservableObject {
    @Published var selectedPiHole: Pihole?
    @Published var isSetupPresented = false
    
    func openPiholeSetup(_ pihole: Pihole? = nil) {
        selectedPiHole = pihole;
        isSetupPresented = true
    }
}

struct PiholeStatsList: View {
    @StateObject private var viewModel = StatsListConfig()
    @EnvironmentObject private var userPreferences: UserPreferences
    @EnvironmentObject private var piholeProviderListManager: PiholeDataProviderListManager
    @Environment(\.scenePhase) private var phase
    /*
     I want to make this logic on the @App but it seems there's a bug on Beta2
     More info here: https://twitter.com/fcbunn/status/1281905574695886848?s=21
     */

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                if userPreferences.displayAllPiholes {
                    StatsView(dataProvider: piholeProviderListManager.allPiholesProvider)
                    Divider()
                }
                ForEach(piholeProviderListManager.providerList, id: \.id) { provider in
                    StatsView(dataProvider: provider)
                        .onTapGesture() {
                            viewModel.openPiholeSetup(provider.piholes.first)
                        }
                }
                
                Button(action: {
                    viewModel.openPiholeSetup()
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
                if piholeProviderListManager.isEmpty {
                    Text(UIConstants.Strings.addFirstPiholeCaption)
                }
            }
            .sheet(isPresented: $viewModel.isSetupPresented) {
                PiholeSetupView(pihole: viewModel.selectedPiHole)
                    .environmentObject(piholeProviderListManager)
            }
        }.navigationTitle(UIConstants.Strings.piholesNavigationTitle)
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                print("active")
            case .inactive:
                print("inactive")
            case .background:
                WidgetCenter.shared.reloadAllTimelines()
            @unknown default: break
                // Fallback for future cases
            }
        }
    }
}


struct PiholeStatsList_Previews: PreviewProvider {
    static var previews: some View {
        PiholeStatsList()
            .environmentObject(UserPreferences())
            .environmentObject(PiholeDataProviderListManager.previewData())
    }
}
