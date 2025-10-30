import Combine
import CoreBluetooth
import SwiftUI

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    @Published var status: ManagerStatus = .ready
    @Published var deviceErrors: [DeviceErrorInfo] = []
    @Published var deviceStore = DeviceStore()

    private var centralManager: CBCentralManager!

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func sendValue(_ value: UInt8, _ device: CBUUID) throws {
        if case let .bluetoothUnavailable(reason) = status {
            throw ManagerError.unavailable(reason: reason)
        }

        status = .scanning
        centralManager.scanForPeripherals(withServices: [Constants.serviceUUID], options: nil)
    }

//    func disconnect() {
//        if let peripheral = discoveredPeripheral {
//            centralManager.cancelPeripheralConnection(peripheral)
//        }
//    }

    // MARK: - CBCentralManagerDelegate

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            status = .ready
        case .poweredOff:
            status = .bluetoothUnavailable(reason: .poweredOff)
        case .unauthorized:
            status = .bluetoothUnavailable(reason: .unauthorized)
        case .unsupported:
            status = .bluetoothUnavailable(reason: .unsupported)
        default:
            status = .bluetoothUnavailable(reason: .unknown)
        }
    }

    func centralManager(
        _ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any], rssi RSSI: NSNumber
    ) {

        if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID],
           serviceUUIDs.contains(Constants.serviceUUID)
        {

//            statusMessage = "Found device: \(peripheral.name ?? peripheral.identifier.uuidString)"

//            discoveredPeripheral = peripheral
//            discoveredPeripheral?.delegate = self

            // TODO: connect when user clicks
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // TODO: Modify device to indicate connection
//        statusMessage = "Connected"
//        isConnected = true
        peripheral.discoverServices([Constants.serviceUUID])
    }

    func centralManager(
        _ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?
    ) {
        deviceErrors.append(DeviceErrorInfo(
            device: peripheral.identifier,
            error: .connectionFailed(error?.localizedDescription)
        ))
    }

    func centralManager(
        _ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?
    ) {
        deviceErrors.append(DeviceErrorInfo(
            device: peripheral.identifier,
            error: .disconnectedUnexpectedly(error?.localizedDescription)
        ))
    }

    // MARK: - CBPeripheralDelegate

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            let err =
                DeviceError
                .serviceDiscoveryFailed(error.localizedDescription)
            
            deviceErrors.append(DeviceErrorInfo(device: peripheral.identifier, error: err))
            return
        }

        guard let services = peripheral.services, !services.isEmpty else {
            deviceErrors
                .append(
                    DeviceErrorInfo(
                        device: peripheral.identifier,
                        error: DeviceError.noServices
                    )
                )
            return
        }

        for service in services {
            if service.uuid == Constants.serviceUUID {
                peripheral
                    .discoverCharacteristics(
                        Constants.easySpotCharacteristics,
                        for: service
                    )
                return
            }
        }

        deviceErrors.append(DeviceErrorInfo(device: peripheral.identifier, error: .serviceNotFound))
    }

    func peripheral(
        _ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?
    ) {
        if let error = error {
            deviceErrors.append(DeviceErrorInfo(
                device: peripheral.identifier,
                error: .characteristicsDiscoveryFailed(error.localizedDescription)
            ))
            return
        }

        guard let characteristics = service.characteristics else {
            deviceErrors
                .append(
                    DeviceErrorInfo(
                        device: peripheral.identifier,
                        error: .noCharacteristics
                    )
                )
            return
        }
        
        var device = Device(
            id: peripheral.identifier,
            name: peripheral.name,
            peripheral: peripheral,
            status: .visible,
            characteristics: EasySpotCharacteristics(),
            rssi: 0
        )

        for characteristic in characteristics {
            if characteristic.uuid == Constants.CharacteristicUUIDs.status {
                device.characteristics.status = characteristic
            }
            // TODO: Check queue
        }
    }
    
    func setEnabled(device: Device, _ enabled: Bool) {
        guard let characteristic = device.characteristics.status else {
            deviceErrors.append(DeviceErrorInfo(
                device: device.id,
                error: .missingCharacteristic(Constants.Characteristic.status)
            ))
            return
        }
        
        self.writeRawValue(
            peripheral: device.peripheral,
            characteristic: characteristic,
            enabled ? 1 : 0,
        )
    }
    
    func writeRawValue(
        peripheral: CBPeripheral,
        characteristic: CBCharacteristic,
        _ value: UInt8
    ) {
        let data = Data([value])
        
        if characteristic.properties.contains(.write) {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        } else if characteristic.properties.contains(.writeWithoutResponse) {
            peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
        } else {
            deviceErrors.append(DeviceErrorInfo(
                device: peripheral.identifier,
                error: .WriteNotSupported
            ))
        }
    }

//    func writeValue(_ value: UInt8, to characteristic: CBCharacteristic) {
//        guard let peripheral = discoveredPeripheral else {
//            statusMessage = "No connected peripheral"
//            return
//        }
//
//        let data = Data([value])
//
//        if characteristic.properties.contains(.write) {
//            peripheral.writeValue(data, for: characteristic, type: .withResponse)
//        } else if characteristic.properties.contains(.writeWithoutResponse) {
//            peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
//            statusMessage = "Wrote value: \(value)"
//            disconnect()
//        } else {
//            deviceErrors.append(DeviceErrorInfo(
//                device: peripheral.identifier,
//                error: .WriteNotSupported
//            ))
//        }
//    }

    func peripheral(
        _ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?
    ) {
        if let error = error {
            deviceErrors.append(DeviceErrorInfo(
                device: peripheral.identifier,
                error: .writeFailed(error.localizedDescription)
            ))
            return
        }

    }
}
