//
//  Errors.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//

import Foundation

enum ManagerError: Error {
    case unavailable(reason: BluetoothUnavailableReason)
}

enum DeviceError: Error {
    // MARK: - Service discovery
    case serviceDiscoveryFailed(_ localizedDescription: String)
    case noServices
    case serviceNotFound
    // MARK: - Characteristic discovery
    case characteristicsDiscoveryFailed(_ localizedDescription: String)
    case noCharacteristics
    // MARK: - Connection
    case connectionFailed(_ localizedDescription: String?)
    case disconnectedUnexpectedly(_ localizedDescription: String?)
    // MARK: - Writing
    case writeFailed(_ localizedDescription: String?)
    /// Characteristic does not support writing
    case WriteNotSupported
}

/// Used to display in the UI error information related to a specific device.
struct DeviceErrorInfo: Error {
    let device: UUID
    let error: DeviceError
}
