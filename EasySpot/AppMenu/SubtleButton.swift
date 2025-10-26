//
//  SubtleButton.swift
//  EasySpot
//
//  Created by Tymek on 26/10/2025.
//

import SwiftUI

struct SubtleButton<Content: View>: View {
    let action: @MainActor () -> Void
    let content: () -> Content
    
    @State private var hovering = false
    
    var body: some View {
        Button(action: action) {
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.borderless)
        .frame(width: 24, height: 24)
        .background(hovering ? Color.gray.opacity(0.2) : Color.clear)
        .cornerRadius(24)
        .onHover(perform: { inside in
            hovering = inside
        })
    }
}

#Preview {
    SubtleButton(action: {}) {
        Text("A")
    }
}
