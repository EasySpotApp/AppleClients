//
//  AppMenu.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//

import SwiftUI

struct AppMenu: View {
    @State private var showGreeting = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("TrayIconEnabled")
                    .renderingMode(.template)
                    .foregroundStyle(Color(nsColor: .headerTextColor))
                
                Text("EasySpot")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(nsColor: .headerTextColor))
                
                Spacer()
                
                Text("Settings")
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: 300)
    }
}

#Preview {
    AppMenu()
}
