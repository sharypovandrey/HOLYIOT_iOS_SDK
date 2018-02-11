//
//  Device.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 16.01.18.
//

import CoreBluetooth

public typealias Sensor = CBCharacteristic

public typealias State = CBPeripheralState

public typealias Service = CBService

public typealias Peripherial = CBPeripheral


protocol DeviceProtocol: NSObjectProtocol {
    func updated(id: String)
}

protocol DiscoverProtocol: NSObjectProtocol {
    func discoverSensor(_ sensor: Sensor)
    func didUpdateValueFor(_ sensor: Sensor)
}

class Device: NSObject, DiscoverProtocol {
    
    var id: String {
        return peripheral.id
    }
    
    var rssi: NSNumber = 0
    
    var name: String? {
        return peripheral.name
    }
    
    var stayConnected: Bool = false
    
    var advertisementData: AdvertisementData?
    
    var state: State {
        return peripheral.state
    }
    
    var services: [Service] {
        if let services = peripheral.services {
            return services
        }
        return []
    }
    
    private var peripheral: Peripherial!
    
    init(peripheral: Peripherial) {
        super.init()
        self.peripheral = peripheral
        peripheral.delegate = self
    }
    
    convenience init(peripheral: Peripherial, advertisementData: [String : Any]?, rssi: NSNumber) {
        self.init(peripheral: peripheral)
        if let advertisementData = advertisementData {
            self.advertisementData = AdvertisementData(advertisementData)
        }
        self.rssi = rssi
    }
    
    func readRSSI() {
        peripheral.readRSSI()
    }
    
    func turnOn() -> Bool {
        guard state == .connected else {return false}
        guard let power = peripheral.findCharacteristicWithSensorType(.power) else {fatalError("no power characteristic")}
        peripheral.writeCommand(.turnOn, for: power)
        return true
    }
    
    func turnOff() {
        guard state == .connected else {return}
        guard let power = peripheral.findCharacteristicWithSensorType(.power) else {fatalError("no power characteristic")}
        peripheral.writeCommand(.turnOff, for: power)
    }
    
    func setNotifyValue(_ value: Bool, for sensorType: SensorType) {
        guard state == .connected else {return}
        guard let characteristic = peripheral.findCharacteristicWithSensorType(sensorType) else {fatalError("no sensorType characteristic")}
        peripheral.setNotifyValue(value, for: characteristic)
    }
    
    func connect() {
        HolyCentralManager.shared.connect(id: id)
    }
    
    func disconnect() {
        HolyCentralManager.shared.disconnect(id: id)
    }
    
    func connected() {
        print("Device connected")
    }
    
    func disconnected() {
        print("Device disconnected")
    }
    
    static func ==(lhs: Device, rhs: Device) -> Bool {
        return lhs.id == rhs.id
    }
    
    func discoverSensor(_ sensor: Sensor) {}
    func didUpdateValueFor(_ sensor: Sensor) {}
}

extension Device: CBPeripheralDelegate {
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        for service in invalidatedServices {
//            peripheral.discoverIncludedServices(nil, for: service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("peripheral \(peripheral.name) didReadRSSI \(RSSI) error \(error)")
        rssi = RSSI
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        print("didDiscoverServices peripheral \(peripheral.name) error \(error)")
        guard let services = peripheral.services else {return}
        for service in services {
//            peripheral.discoverIncludedServices(nil, for: service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
//        print("didDiscoverIncludedServicesFor peripheral \(peripheral.name) error \(error)")
//        guard let services = peripheral.services else {return}
//        print("didDiscoverIncludedServicesFor \(services)")
//        for service in services {
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        print("didDiscoverCharacteristicsFor peripheral \(peripheral.name) of service \(service) error \(error)")
        guard let characteristics = service.characteristics else {return}
        for characteristic in characteristics {
            discoverSensor(characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        print("didUpdateValueFor peripheral \(peripheral.name) of characteristic \(characteristic.properties) error \(error)")
        didUpdateValueFor(characteristic)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("peripheral \(peripheral.name) didWriteValueFor characteristic \(characteristic.properties) error \(error)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("peripheral \(peripheral.name) didUpdateNotificationStateFor characteristic \(characteristic.id) isNotifying \(characteristic.isNotifying) error \(error)")
    }
    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//        print("peripheral \(peripheral.name) didDiscoverDescriptorsFor characteristic \(characteristic.properties) error \(error)")
//    }
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
//        print("peripheral \(peripheral.name) didUpdateValueFor \(descriptor) error \(error)")
//    }

//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
//        print("peripheral \(peripheral.name) didWriteValueFor \(descriptor) error \(error)")
//    }
    
//    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
//        print("peripheralIsReady toSendWriteWithoutResponse \(peripheral.name)")
//    }
    
    @available(iOS 11.0, *)
    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
        
    }
}
