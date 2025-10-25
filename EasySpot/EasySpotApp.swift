//
//  EasySpotApp.swift
//  EasySpot
//
//  Created by Tymek on 24/10/2025.
//

import SwiftUI

@main
struct EasySpotApp: App {
    
    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
        #if os(macOS)
        MenuBarExtra {
            AppMenu()
        }
        label: {
            Image("TrayIconDisabled").renderingMode(.template)
        }
        .menuBarExtraStyle(.window)
        #endif
    }
}
