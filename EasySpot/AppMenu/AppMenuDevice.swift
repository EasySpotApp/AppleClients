//
//  AppMenuDevice.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//

#if os(macOS)

import SwiftUI

private struct Item: View {
    let deviceName: String
    @Binding var expanded: Bool
    
    var body: some View {
        HStack {
            IconBox {
                Image(systemName: "iphone.homebutton")
            }
            Text(deviceName)
            
            Spacer()
            
            SubtleButton(action: {
                expanded.toggle()
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.gray)
                    .rotationEffect(.degrees(expanded ? 90 : 0))
                    .animation(.easeInOut(duration: 0.2), value: expanded)
            }
        }
    }
}

struct AppMenuDevice: View {
    let deviceName: String
    let action: () -> Void
    
    @State private var expanded = false
    
    var body: some View {
        VStack {
            MenuOption(action: action) {
                Item(deviceName: deviceName, expanded: $expanded)
            }
        }
    }
}

#Preview {
    AppMenuDevice(deviceName: "Test Device", action: {})
}

#endif
