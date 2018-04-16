//
//  HolyIOT+CoreBluetooth.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//

import Foundation
import CoreBluetooth

enum SensorType: String {
    case accelerometer
    case gyroscope
    case magnetometer
    case barometer
    case humidity
    case temperature
    case sfl
    case status
    case power
    case powerAnswer
    case unknown
    
    init(rawValue: String) {
        switch rawValue {
        case HolyIOT.accelerometerUUID:
            self = .accelerometer
        case HolyIOT.gyroscopeUUID:
            self = .gyroscope
        case HolyIOT.magnetometerUUID:
            self = .magnetometer
        case HolyIOT.barometerUUID:
            self = .barometer
        case HolyIOT.humidityUUID:
            self = .humidity
        case HolyIOT.temperatureUUID:
            self = .temperature
        case HolyIOT.sflUUID:
            self = .sfl
        case HolyIOT.statusUUID:
            self = .status
        case HolyIOT.powerUUID:
            self = .power
        case HolyIOT.powerAnswerUUID:
            self = .powerAnswer
        default:
            self = .unknown
        }
    }
}

/*!
 *  @class HolyIOT
 *
 *  @discussion Represents a HolyIOT's constants and CB extensions.
 */
final class HolyIOT {
    
    
    /*old UUIDs*/
    static let advertisementServiceUUID = "6E400000-B5A3-F393-E0A9-E50E24DCCA9E"
//    fileprivate static let powerUUID = "2EA78970-7D44-44BB-B097-26183F402409"
//    fileprivate static let accelerometerUUID = "2EA78970-7D44-44BB-B097-26183F402401"
//    fileprivate static let gyroscopeUUID = "2EA78970-7D44-44BB-B097-26183F402402"
    
    static let deviceName: String = "Holy-IOT"
    
    /*old UUIDs always should be uppercased*/
    static let serviceUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
    fileprivate static let accelerometerUUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
    fileprivate static let gyroscopeUUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
    fileprivate static let magnetometerUUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
    fileprivate static let barometerUUID = "6E400004-B5A3-F393-E0A9-E50E24DCCA9E"
    fileprivate static let humidityUUID = "6E400005-B5A3-F393-E0A9-E50E24DCCA9E"
    fileprivate static let temperatureUUID = "6E400006-B5A3-F393-E0A9-E50E24DCCA9E"
    fileprivate static let sflUUID = "6E400007-B5A3-F393-E0A9-E50E24DCCA9E"
    fileprivate static let statusUUID = "6E400008-B5A3-F393-E0A9-E50E24DCCA9E"
    fileprivate static let powerUUID = "6E400009-B5A3-F393-E0A9-E50E24DCCA9E"
    fileprivate static let powerAnswerUUID = "6E40000A-B5A3-F393-E0A9-E50E24DCCA9E"
    
    static var cbuuid: CBUUID {
        return CBUUID(string: advertisementServiceUUID)
    }
}

extension CBPeripheral {
    var isConnected: Bool {
        return state == .connected
    }
    
    
    func getServiceWith(_ id: String) -> CBService? {
        
        guard let services = services else {return nil}
        
        for service in services {
            if service.id == id {
                return service
            }
        }
        return nil
    }
    
    func writeCommand(_ command: PowerCommand, for characteristic: CBCharacteristic) {
        let data = Data.dataWithValue(value: command.rawValue)
        writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func findCharacteristicWithSensorType(_ sensorType: SensorType) -> CBCharacteristic? {
        guard let services = services else{return nil}
        for service in services {
            if let characteristic = service.findCharacteristicWithSensorType(sensorType) {
                return characteristic
            }
        }
        return nil
    }
}

extension CBService {
    var isHolyIOT: Bool {
        return id == HolyIOT.serviceUUID
    }
    
    func findCharacteristicWithSensorType(_ sensorType: SensorType) -> CBCharacteristic? {
        guard let characteristics = characteristics else{return nil}
        return characteristics.first{$0.sensorType == sensorType}
    }
    
    func findCharacteristicWith(_ id: String) -> CBCharacteristic? {
        guard let characteristics = characteristics else {return nil}
        for characteristic in characteristics {
            if characteristic.id == id.uppercased() {
                return characteristic
            }
        }
        return nil
    }
}

extension CBCharacteristic {
    
    var sensorType: SensorType {
        return SensorType(rawValue: id)
    }
    var isAccelerometer: Bool {
        return id == HolyIOT.accelerometerUUID
    }
    var isGyroscope: Bool {
        return id == HolyIOT.gyroscopeUUID
    }
    var isMagnetometer: Bool {
        return id == HolyIOT.magnetometerUUID
    }
    var isBarometer: Bool {
        return id == HolyIOT.barometerUUID
    }
    var isHumidity: Bool {
        return id == HolyIOT.humidityUUID
    }
    var isTemperature: Bool {
        return id == HolyIOT.temperatureUUID
    }
    var isSFL: Bool {
        return id == HolyIOT.sflUUID
    }
    var isStatus: Bool {
        return id == HolyIOT.statusUUID
    }
    var isPower: Bool {
        return id == HolyIOT.powerUUID
    }
    var isPowerAnswer: Bool {
        return id == HolyIOT.powerAnswerUUID
    }
}

extension CBPeer {
    var id: String {
        return identifier.uuidString
    }
}

extension CBAttribute {
    var id: String {
        return uuid.uuidString
    }
}
