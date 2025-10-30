//
//  Constants.swift
//  EasySpot
//
//  Created by Tymek on 25/10/2025.
//

import CoreBluetooth

struct Constants {
    static let serviceUUID = CBUUID(string: "7BAAD717-1551-45E1-B852-78D20C7211EC")
    
    struct CharacteristicUUIDs {
        static let status = CBUUID(string: "47436878-5308-40F9-9C29-82C2CB87F595")
    }
    
    enum Characteristic {
        case status
    }
    
    static let easySpotCharacteristics = [CharacteristicUUIDs.status]
}
