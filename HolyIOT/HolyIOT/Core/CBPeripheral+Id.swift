//
//  CBPeripheral+Id.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 10.01.18.
//

import CoreBluetooth

extension CBPeripheral {
    var id: String {
        return identifier.uuidString
    }
}
