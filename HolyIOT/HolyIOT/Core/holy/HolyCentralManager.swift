//
//  HolyCentralManager.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.01.18.
//
import CoreBluetooth
import UIKit

protocol HolyCentralManagerProtocol: NSObjectProtocol {
    func detected(device: HolyDevice)
    func connected(_ deviceId: String)
    func disconnected(_ deviceId: String)
    func bluetoothPoweredOff()
}

class HolyCentralManager: NSObject {
    
    typealias WeakRefDevice = WeakRef<Device>
    
    var centralManager: CBCentralManager!
    
//    var serviceUUIDs: [CBUUID]?
//
//    var requiredServiceUUIDs: [String]? {
//        didSet {
//            serviceUUIDs = requiredServiceUUIDs?.map {CBUUID(string: $0)} ?? []
//        }
//    }
//
//    var requiredCharacteristicUUIDs: [String]?
//
//    var requiredNames: [String]?
    
    private var devices: [String : WeakRefDevice] = [:]
    
    weak var delegate: HolyCentralManagerProtocol?
    
    private override init() {
        super.init()
        let options = [CBCentralManagerOptionShowPowerAlertKey: true]
        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
        
    }
    
    public static let shared = HolyCentralManager()
    
    func addDevice(device: HolyDevice) -> Bool {
        devices = devices.filter { $0.value.value != nil }
        if devices[device.id] != nil {return false}
        devices[device.id] = WeakRefDevice(value: device)
        return true
    }
    
    func deviceWith(id: String) -> Device? {
        if let wrapper = devices[id] {
            return wrapper.value
        } else {
            return nil
        }
    }
}

protocol HolyConnectProtocol: NSObjectProtocol {
    func connect(id: String)
    func disconnect(id: String)
}

protocol HolyScanProtocol: NSObjectProtocol {
    func startScan()
    func stopScan()
}

extension HolyCentralManager: CBCentralManagerDelegate, HolyScanProtocol, HolyConnectProtocol {
    
    func connect(id: String) {
        let peripherals = centralManager.retrievePeripherals(withIdentifiers: [UUID(uuidString: id)!])
        if peripherals.count > 0 {
            centralManager.connect(peripherals[0], options: nil)
        }
    }
    
    func disconnect(id: String) {
        let peripherals = centralManager.retrievePeripherals(withIdentifiers: [UUID(uuidString: id)!])
        if peripherals.count > 0 {
            centralManager.cancelPeripheralConnection(peripherals[0])
        }
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
    
    func startScan() {
        centralManager.scanForPeripherals(withServices: [HolyIOT.cbuuid], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        print("centralManager didConnect \(peripheral.name)")
        if let device = deviceWith(id: peripheral.id) {
            device.connected()
        }
        delegate?.connected(peripheral.id)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("centralManager didDisconnect \(peripheral.name)")
        if let device = deviceWith(id: peripheral.id) {
            device.disconnected()
        }
        delegate?.disconnected(peripheral.id)
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = HolyDevice(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
        if addDevice(device: device) {
            delegate?.detected(device: device)
        }
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("willRestoreState \(dict)")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOff {
            delegate?.bluetoothPoweredOff()
        }
    }
}

//extension HolyCentralManager: CBPeripheralDelegate {
//
//    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
//
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
//        for service in invalidatedServices {
//            peripheral.discoverIncludedServices(nil, for: service)
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//
//
//    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
//        print("peripheral \(peripheral.name) didReadRSSI \(RSSI) error \(error)")
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        print("peripheral \(peripheral.name) didDiscoverServices error \(error)")
//        guard let services = peripheral.services else {return}
//        print("didDiscoverServices \(services)")
//        for service in services {
//            peripheral.discoverIncludedServices(nil, for: service)
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        print("peripheral \(peripheral.name) didDiscoverCharacteristicsFor service \(service) error \(error)")
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        print("peripheral \(peripheral.name) didUpdateValueFor characteristic \(characteristic.properties) error \(error)")
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        print("peripheral \(peripheral.name) didWriteValueFor characteristic \(characteristic.properties) error \(error)")
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//        print("peripheral \(peripheral.name) didUpdateNotificationStateFor characteristic \(characteristic.properties) error \(error)")
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//        print("peripheral \(peripheral.name) didDiscoverDescriptorsFor characteristic \(characteristic.properties) error \(error)")
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
//        print("peripheral \(peripheral.name) didUpdateValueFor \(descriptor) error \(error)")
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
//        print("peripheral \(peripheral.name) didWriteValueFor \(descriptor) error \(error)")
//    }
//
//    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
//        print("peripheralIsReady toSendWriteWithoutResponse \(peripheral.name)")
//    }
//
//    @available(iOS 11.0, *)
//    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
//
//    }
//}

