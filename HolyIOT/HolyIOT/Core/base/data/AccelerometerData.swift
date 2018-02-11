//
//  AccelerometerData.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//

import Foundation
import CoreBluetooth

enum AccelerometerRange : Int {
    case ACC_2G = 3
    case ACC_4G = 5
    case ACC_8G = 8
    case ACC_16G = 12
    
    var ratio: Float {
        switch self {
        case .ACC_2G:
            return 2.0
        case .ACC_4G:
            return 4.0
        case .ACC_8G:
            return 8.0
        case .ACC_16G:
            return 16.0
        }
    }
}

struct AccelerometerData: CustomStringConvertible {
    
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
        let dafaultRange = AccelerometerRange.ACC_2G
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
        self.init(rawX: rawX, rawY: rawY, rawZ: rawZ, range: .ACC_2G)
    }
    
    init(rawX: Float, rawY: Float, rawZ: Float, range: AccelerometerRange) {
        self.x = rawX * range.ratio
        self.y = rawY * range.ratio
        self.z = rawZ * range.ratio
        self.max = range.ratio
        self.min = -range.ratio
    }
    
    var description: String {
        return String(format: "x: %.2fG, y: %.2fG, z: %.2fG, min: %dG, max: %dG", x, y, z, Int(min), Int(max))
    }
}

extension CBCharacteristic {
    
    fileprivate var divider: Float {
        return 16384.0
    }
    
    func fetchAccelerometerData(_ range: AccelerometerRange?) -> AccelerometerData {
        guard let range = range else {fatalError("AccelerometerRange is not specified")}
        if let value = value {
            let byteArray = [UInt8](value)
            guard byteArray.count == 9 else {return AccelerometerData()}
            let rawX = Float(Int16(byteArray[3]) | Int16(byteArray[4]) << 8) / divider
            let rawY = Float(Int16(byteArray[5]) | Int16(byteArray[6]) << 8) / divider
            let rawZ = Float(Int16(byteArray[7]) | Int16(byteArray[8]) << 8) / divider
            return AccelerometerData(rawX: rawX, rawY: rawY, rawZ: rawZ, range: range)
        } else {
            return AccelerometerData()
        }
    }
}

