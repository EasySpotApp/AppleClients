//
//  MenuOption.swift
//  EasySpot
//
//  Created by Tymek on 26/10/2025.
//

import SwiftUI

struct MenuOption<Content: View>: View {
    let action: @MainActor () -> Void
    let content: () -> Content
    
    @State private var hovering = false

    var body: some View {
        VStack {
            Button(action: action) {
                HStack {
                    content()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
            }
            .buttonStyle(.borderless)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(hovering ? Color.gray.opacity(0.2) : Color.clear)
            .cornerRadius(4)
            .onHover(perform: { inside in
                hovering = inside
            })
        }
        .padding(.horizontal, 5)
    }
}

#Preview {
    MenuOption(action: {}) {
        Text("A")
    }
}
