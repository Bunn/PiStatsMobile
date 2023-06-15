//
//  BackDeployableShims.swift
//  PiStatsWidgetExtension
//
//  Created by Guilherme Rambo on 13/06/23.
//

import SwiftUI
import WidgetKit

extension View {
    @ViewBuilder
    func widgetBackground() -> some View {
        if #available(iOS 17.0, *) {
            containerBackground(.background, for: .widget)
        } else {
            self
        }
    }

    @ViewBuilder
    func numericContentTransition(countsDown: Bool = false) -> some View {
        if #available(iOSApplicationExtension 16.0, *) {
            contentTransition(.numericText(countsDown: countsDown))
        } else {
            self
        }
    }

    #if DEBUG
    /// Workaround for WidgetKit previews using old-style PreviewProvider
    /// not respecting the `contentMarginsDisabled()` modifier
    /// when previewing on iOS 17 Simulator.
    @ViewBuilder
    func disableContentMarginsForPreview() -> some View {
        padding(-16)
    }
    #endif
}
