import Combine
import CoreBluetooth
import SwiftUI

// MARK: - Bluetooth Manager

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    @Published var statusMessage: String = "Ready"
    @Published var isConnected: Bool = false
    @Published var isScanning: Bool = false
    
    private var centralManager: CBCentralManager!
    private var discoveredPeripheral: CBPeripheral?
    private var targetCharacteristic: CBCharacteristic?
    private var pendingValue: UInt8?

    let serviceUUID = CBUUID(string: "7BAAD717-1551-45E1-B852-78D20C7211EC")
    let characteristicUUID = CBUUID(string: "47436878-5308-40F9-9C29-82C2CB87F595")

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func sendValue(_ value: UInt8) {
        guard centralManager.state == .poweredOn else {
            statusMessage = "Bluetooth is not powered on"
            return
        }

        pendingValue = value
        statusMessage = "Scanning for devices..."
        isScanning = true
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }

    func disconnect() {
        if let peripheral = discoveredPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }

    // MARK: - CBCentralManagerDelegate

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            statusMessage = "Bluetooth ready"
        case .poweredOff:
            statusMessage = "Bluetooth is powered off"
        case .unauthorized:
            statusMessage = "Bluetooth is unauthorized"
        case .unsupported:
            statusMessage = "Bluetooth is not supported"
        default:
            statusMessage = "Bluetooth state: \(central.state.rawValue)"
        }
    }

    func centralManager(
        _ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any], rssi RSSI: NSNumber
    ) {

        if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID],
            serviceUUIDs.contains(serviceUUID)
        {

            statusMessage = "Found device: \(peripheral.name ?? peripheral.identifier.uuidString)"

            discoveredPeripheral = peripheral
            discoveredPeripheral?.delegate = self

            centralManager.stopScan()
            isScanning = false
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        statusMessage = "Connected"
        isConnected = true
        peripheral.discoverServices([serviceUUID])
    }

    func centralManager(
        _ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?
    ) {
        statusMessage = "Failed to connect: \(error?.localizedDescription ?? "Unknown error")"
        isScanning = false
        isConnected = false
    }

    func centralManager(
        _ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?
    ) {
        isConnected = false
        if let error = error {
            statusMessage = "Disconnected with error: \(error.localizedDescription)"
        } else {
            statusMessage = "Disconnected"
        }
    }

    // MARK: - CBPeripheralDelegate

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            statusMessage = "Error discovering services: \(error.localizedDescription)"
            return
        }

        guard let services = peripheral.services, !services.isEmpty else {
            statusMessage = "No services found"
            return
        }

        for service in services {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
                return
            }
        }

        statusMessage = "Target service not found"
    }

    func peripheral(
        _ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?
    ) {
        if let error = error {
            statusMessage = "Error discovering characteristics: \(error.localizedDescription)"
            return
        }

        guard let characteristics = service.characteristics else {
            statusMessage = "No characteristics found"
            return
        }

        for characteristic in characteristics {
            if characteristic.uuid == characteristicUUID {
                targetCharacteristic = characteristic

                if let value = pendingValue {
                    writeValue(value, to: characteristic)
                }
                return
            }
        }

        statusMessage = "Characteristic not found"
    }

    func writeValue(_ value: UInt8, to characteristic: CBCharacteristic) {
        guard let peripheral = discoveredPeripheral else {
            statusMessage = "No connected peripheral"
            return
        }

        let data = Data([value])

        if characteristic.properties.contains(.write) {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        } else if characteristic.properties.contains(.writeWithoutResponse) {
            peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
            statusMessage = "Wrote value: \(value)"
            disconnect()
        } else {
            statusMessage = "Characteristic does not support write"
        }
    }

    func peripheral(
        _ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?
    ) {
        if let error = error {
            statusMessage = "Error writing value: \(error.localizedDescription)"
            return
        }

        if let value = pendingValue {
            statusMessage = "Wrote value: \(value)"
        } else {
            statusMessage = "Write successful"
        }

        disconnect()
    }
}
