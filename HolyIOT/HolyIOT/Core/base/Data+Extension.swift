//
//  Data+Extension.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 11.01.18.
//

import Foundation

extension Data {
    static func dataWithValue(value: Int8) -> Data {
        var variableValue = value
        return Data(buffer: UnsafeBufferPointer(start: &variableValue, count: 1))
    }
    
    func int8Value() -> Int8 {
        return Int8(bitPattern: self[0])
    }
    
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
