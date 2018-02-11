//
//  CBPeripheral+Id.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 10.01.18.
//

import CoreBluetooth

extension CBPeripheral {
    static func ==(lhs: CBPeripheral, rhs: CBPeripheral) -> Bool {
        return lhs.id == rhs.id
    }
}
