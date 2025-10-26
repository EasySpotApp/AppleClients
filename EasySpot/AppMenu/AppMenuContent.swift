//
//  AppMenuContent.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//
#if os(macOS)

import SwiftUI

struct AppMenuContent: View {
    @State private var showGreeting = true
    
    var body: some View {
        VStack(spacing: 5) {
            AppMenuHeader()
            
//            Divider().padding(.horizontal, 14)
            
            Text("Your Devices")
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
//                .padding(.top, 3)
            
            AppMenuDevice(deviceName: "Test")
        }
        .frame(maxWidth: 300, alignment: .leading)
        
    }
}

#Preview {
    AppMenuContent()
}

#endif
