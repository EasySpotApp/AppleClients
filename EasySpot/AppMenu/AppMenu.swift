//
//  AppMenu.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//
#if os(macOS)

import SwiftUI

struct AppMenu: View {
    @State private var showGreeting = true
    
    var body: some View {
        VStack {
            AppMenuHeader()
        }
        .frame(maxWidth: 300)
    }
}

#Preview {
    AppMenu()
}

#endif
