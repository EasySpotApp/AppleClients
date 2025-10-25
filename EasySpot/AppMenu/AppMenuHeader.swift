//
//  AppMenuHeader.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//

import SwiftUI

struct AppMenuHeader: View {
    @State private var showGreeting = true
    
    var body: some View {
        HStack {
            Image("TrayIconEnabled")
                .renderingMode(.template)
                .foregroundStyle(Color(nsColor: .headerTextColor))
                
            Text("EasySpot")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color(nsColor: .headerTextColor))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AppMenu()
}
