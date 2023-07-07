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
}
