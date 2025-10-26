//
//  IconBox.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//

import SwiftUI

struct IconBox<Content: View>: View {
    let selected: Bool = false
    let content: () -> Content
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                content()
            }
            
            Spacer()
        }
        .frame(width: 26, height: 26)
        .background(selected ? Color.accentColor : Color.gray.opacity(0.3))
        .cornerRadius(26)
    }
}

#Preview {
    IconBox {
        Text("A")
    }
}
