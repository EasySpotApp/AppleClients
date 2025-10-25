//
//  Status.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//

import Foundation

enum ManagerStatus: Equatable {
    case ready
    case scanning
    case bluetoothUnavailable(reason: BluetoothUnavailableReason)
}

enum BluetoothUnavailableReason: Equatable {
    case poweredOff
    case unsupported
    case unauthorized
    case unknown
}
