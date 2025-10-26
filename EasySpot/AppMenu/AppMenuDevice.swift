//
//  AppMenuDevice.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//

#if os(macOS)

import SwiftUI

struct AppMenuDevice: View {
    let deviceName: String
    
    var body: some View {
        MenuOption(action: {}) {
            HStack {
                IconBox {
                    Image(systemName: "iphone.homebutton")
                }
                Text(deviceName)
                
                Spacer()
            }
        }
    }
}

#Preview {
    AppMenuDevice(deviceName: "Test Device")
}

#endif
