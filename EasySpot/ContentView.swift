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
    @State private var valueToSend: UInt8 = 0
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Status indicator
                HStack {
                    Circle()
                        .fill(bluetoothManager.isConnected ? Color.green : Color.gray)
                        .frame(width: 12, height: 12)

                    Text(bluetoothManager.statusMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()

                Divider()

                // Value input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Value to Send")
                        .font(.headline)

                    HStack {
                        Menu {
                            Button("True (1)") { valueToSend = 1 }
                            Button("False (0)") { valueToSend = 0 }
                        } label: {
                            Text("Boolean")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()

                // Send button
                Button(action: sendValue) {
                    HStack {
                        Image(
                            systemName: bluetoothManager.isScanning
                                ? "antenna.radiowaves.left.and.right" : "paperplane.fill")
                        Text(bluetoothManager.isScanning ? "Scanning..." : "Send")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canSend ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(!canSend)
                .padding()

                // Disconnect button
                if bluetoothManager.isConnected {
                    Button(action: {
                        bluetoothManager.disconnect()
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text("Disconnect")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("Bluetooth Control")
            .alert("Invalid Value", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    private var canSend: Bool {
        !bluetoothManager.isScanning && !bluetoothManager.isConnected
    }

    private func sendValue() {
        bluetoothManager.sendValue(valueToSend)
    }

    private func parseValue(_ string: String) -> UInt8? {
        let lower = string.lowercased().trimmingCharacters(in: .whitespaces)

        switch lower {
        case "true", "yes", "on", "y":
            return 1
        case "false", "no", "off", "n":
            return 0
        default:
            return UInt8(string)
        }
    }
}
