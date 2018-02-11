//
//  MagnetometerData.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//

import Foundation
import CoreBluetooth


struct MagnetometerData: CustomStringConvertible {
    
    let x: Float
    let y: Float
    let z: Float
    
    var isEmpty: Bool {
        return x == 0 && y == 0 && z == 0
    }
    
    init() {
        x = 0
        y = 0
        z = 0
    }
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    var description: String {
        return "x:\(x)uT, y:\(y)uT, z:\(z)uT"
    }
}

extension CBCharacteristic {
    
    var magnetometerData: MagnetometerData {
        if let value = value {
            let byteArray = [UInt8](value)
            guard byteArray.count == 9 else {return MagnetometerData()}
            let x = Float(Int16(byteArray[3]) | Int16(byteArray[4]) << 8)
            let y = Float(Int16(byteArray[5]) | Int16(byteArray[6]) << 8)
            let z = Float(Int16(byteArray[7]) | Int16(byteArray[8]) << 8)
            return MagnetometerData(x: x, y: y, z: z)
        } else {
            return MagnetometerData()
        }
    }
}
