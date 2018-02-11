//
//  SFLData.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 05.02.18.
//

import Foundation
import CoreBluetooth


struct SFLData: CustomStringConvertible {
    
    let x: Float
    let y: Float
    let z: Float
    let w: Float
    
    var isEmpty: Bool {
        return x == 0 && y == 0 && z == 0 && w == 0
    }
    
    init() {
        x = 0
        y = 0
        z = 0
        w = 0
    }
    
    init(x: Float, y: Float, z: Float, w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    var description: String {
        return "x:\(x), y:\(y), z:\(z), w\(w)"
    }
}

extension CBCharacteristic {
    
    var sflData: SFLData {
        if let value = value {
            let byteArray = [UInt8](value)
            guard byteArray.count == 11 else {return SFLData()}
            let x = Float(Int16(byteArray[3]) | Int16(byteArray[4]) << 8)
            let y = Float(Int16(byteArray[5]) | Int16(byteArray[6]) << 8)
            let z = Float(Int16(byteArray[7]) | Int16(byteArray[8]) << 8)
            let w = Float(Int16(byteArray[9]) | Int16(byteArray[10]) << 8)
            return SFLData(x: x, y: y, z: z, w: w)
        } else {
            return SFLData()
        }
    }
}
