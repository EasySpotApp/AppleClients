//
//  ContentView.swift
//  EasySpot
//
//  Created by Tymek on 24/10/2025.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject private var bluetoothManager = BluetoothManager()

    var body: some View {
        DevicesView(bluetoothManager: bluetoothManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
