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
    func deviceStateChanged(_ deviceId: UUID, peripheral: CBPeripheral)
    func connected(device: HolyDevice)
    func disconnected(device: HolyDevice)
    func bluetoothPoweredOff()
}

class HolyCentralManager: NSObject {
    
    var centralManager: CBCentralManager!
    
    var serviceUUIDs: [CBUUID]?
    
    var requiredServiceUUIDs: [String]? {
        didSet {
            serviceUUIDs = requiredServiceUUIDs?.map {CBUUID(string: $0)} ?? []
        }
    }
    
    var requiredCharacteristicUUIDs: [String]?
    
    var requiredNames: [String]?
    
    weak var delegate: HolyCentralManagerProtocol?
    
    private override init() {
        super.init()
        let options = [CBCentralManagerOptionShowPowerAlertKey: true]
        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
        
    }
    
    public static let shared = HolyCentralManager()
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
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.deviceStateChanged(peripheral.identifier, peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.deviceStateChanged(peripheral.identifier, peripheral: peripheral)
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        if peripheral.name != "MacBook Pro — Apple" {
        peripheral.delegate = self
        delegate?.detected(device: HolyDevice(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI))
        print("didDiscover peripheral \(String(describing: peripheral)) advertisementData \(HolyAdvertisementData.stringDictFromAdvertisementData(advertisementData).map({"\($0.key) \($0.value)"}).joined(separator: ", ")) RSSI \(RSSI)")
//        }
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("willRestoreState \(dict)")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState \(central.state)")
        if central.state == .poweredOff {
            delegate?.bluetoothPoweredOff()
        }
    }
}

extension HolyCentralManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("didDiscoverServices peripheral \(peripheral.name)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("didDiscoverCharacteristicsFor peripheral \(peripheral.name) of service \(service)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor peripheral \(peripheral.name) of characteristic \(characteristic.properties)")
    }
}
