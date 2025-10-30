//
//  Device.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//

import Foundation
import CoreBluetooth

struct Device: Identifiable, Equatable {
    let id: UUID
    let name: String?
    let peripheral: CBPeripheral
    var status: DeviceStatus
    var characteristics: EasySpotCharacteristics
    var rssi: Int
    
    static func == (lhs: Device, rhs: Device) -> Bool {
        lhs.id == rhs.id
    }
}

struct EasySpotCharacteristics {
    var status: CBCharacteristic? = .none
}

enum DeviceStatus {
    case visible
    case paired
}
