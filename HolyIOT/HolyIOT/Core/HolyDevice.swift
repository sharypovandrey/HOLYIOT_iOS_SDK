//
//  HolyDevice.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.01.18.
//

import CoreBluetooth

class HolyDevice: NSObject {
    
    typealias DeviceState = CBPeripheralState
    
    typealias HolyService = CBService
    
    var id: String {
        return peripheral.id
    }
    
    var rssi: NSNumber = 0
    
    var name: String? {
        return peripheral.name
    }
    
    var advertisementData: [String : String] = [:]
    
    var state: DeviceState {
        return peripheral.state
    }
    
    var services: [HolyService] = []
    
    var peripheral: CBPeripheral!
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
    
    init(peripheral: CBPeripheral, advertisementData: [String : Any]?, rssi: NSNumber) {
        self.peripheral = peripheral
        if let advertisementData = advertisementData {
            self.advertisementData = HolyAdvertisementData.stringDictFromAdvertisementData(advertisementData)
        }
        self.rssi = rssi
    }
    
    override var debugDescription: String {
        let advString = advertisementData.map{"\($0.key)=\($0.value)"}.joined(separator: ", ")
        let servicesString = services.map { (service) -> String in
            return "\(service)"
        }
        return """
        id: \(id)
        rssi: \(rssi)
        state: \(state)
        advertisementData: \(advString)
        services: \(servicesString)
        """
    }
    
    static func ==(lhs: HolyDevice, rhs: HolyDevice) -> Bool {
        return lhs.id == rhs.id
    }
}
