//
//  GyroscopeData.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//


import Foundation
import CoreBluetooth

enum GyroscopeRange : Int {
    case GYRO_2000 = 0
    case GYRO_1000 = 1
    case GYRO_500 = 2
    case GYRO_250 = 3
    case GYRO_125 = 4
    
    var ratio: Float {
        switch self {
        case .GYRO_2000:
            return 2000.0
        case .GYRO_1000:
            return 1000.0
        case .GYRO_500:
            return 500.0
        case .GYRO_250:
            return 250.0
        case .GYRO_125:
            return 125.0
        }
    }
}

struct GyroscopeData: CustomStringConvertible {
    
    let x: Float
    let y: Float
    let z: Float
    
    let max: Float
    let min: Float
    
    var isEmpty: Bool {
        return x == 0 && y == 0 && z == 0
    }
    
    init() {
        self.init(x: 0, y: 0, z: 0)
    }
    
    init(x: Float, y: Float, z: Float) {
        let dafaultRange = GyroscopeRange.GYRO_2000
        self.init(x: 0, y: 0, z: 0, max: dafaultRange.ratio, min: -dafaultRange.ratio)
    }
    
    init(x: Float, y: Float, z: Float, max: Float, min: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.max = max
        self.min = min
    }
    
    init(rawX: Float, rawY: Float, rawZ: Float) {
        self.init(rawX: rawX, rawY: rawY, rawZ: rawZ, range: .GYRO_2000)
    }
    
    init(rawX: Float, rawY: Float, rawZ: Float, range: GyroscopeRange) {
        self.x = rawX * range.ratio
        self.y = rawY * range.ratio
        self.z = rawZ * range.ratio
        self.max = range.ratio
        self.min = -range.ratio
    }
    
    var description: String {
        return "ox:\(Int(x))d/s, oy:\(Int(y))d/s, oz:\(Int(z))d/s, min:\(Int(min))d/s, max:\(Int(max))d/s"
    }
}

extension CBCharacteristic {
    
    fileprivate var divider: Float {
        return 16384.0
    }
    
    func fetchGyroscopeData(_ range: GyroscopeRange) -> GyroscopeData {
        if let value = value {
            let byteArray = [UInt8](value)
            guard byteArray.count == 9 else {return GyroscopeData()}
            let rawX = Float(Int16(byteArray[3]) | Int16(byteArray[4]) << 8) / divider
            let rawY = Float(Int16(byteArray[5]) | Int16(byteArray[6]) << 8) / divider
            let rawZ = Float(Int16(byteArray[7]) | Int16(byteArray[8]) << 8) / divider
            return GyroscopeData(rawX: rawX, rawY: rawY, rawZ: rawZ, range: range)
        } else {
            return GyroscopeData()
        }
    }
}
