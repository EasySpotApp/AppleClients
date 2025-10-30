//
//  DeviceStore.swift
//  EasySpot
//
//  Created by Tymek on 29/10/2025.
//

import Foundation
import CoreBluetooth

class DeviceStore: ObservableObject {
    @Published private(set) var pairedDevices: [Device] = []
    @Published private(set) var otherDevices: [Device] = []
    private var deviceMap: [UUID: Device] = [:]
    
    func update(_ device: Device) {
        deviceMap[device.id] = device
        
        pairedDevices = deviceMap.values
            .filter { $0.status == .paired }
            .sorted { $0.rssi > $1.rssi }
        
        otherDevices = deviceMap.values
            .filter { $0.status == .visible }
            .sorted { $0.rssi > $1.rssi }
    }
}
