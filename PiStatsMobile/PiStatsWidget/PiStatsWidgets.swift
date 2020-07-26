//
//  PiStatsWidgets.swift
//  PiStatsWidgetExtension
//
//  Created by Fernando Bunn on 21/07/2020.
//

import WidgetKit
import SwiftUI

@main
struct PiStatsWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        ViewStatsWidget()
        ToggleStatusWidget()
    }
}
