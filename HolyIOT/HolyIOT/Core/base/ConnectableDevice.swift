//
//  ConnectableDevice.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 16.01.18.
//

import CoreBluetooth

class ConnectableDevice: Device {
    
//    var callback: ConnectionTimeoutProtocol.ConnectionTimeoutClosure?
//
//    var timer: Timer?
    
//    private var centralManager: CBCentralManager!
    
    override init(peripheral: CBPeripheral) {
        super.init(peripheral: peripheral)
        print("ConnectableDevice init central")
//        let options = [CBCentralManagerOptionShowPowerAlertKey: true]
//        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
    }
    
//    func connect(callback: @escaping ConnectionTimeoutProtocol.ConnectionTimeoutClosure) {
//        connect(timeout: 3, callback: callback)
//    }
//
//    func connect(timeout: ConnectionTimeoutProtocol.Seconds, callback: @escaping ConnectionTimeoutProtocol.ConnectionTimeoutClosure) {
//        print("ConnectableDevice connect")
//        self.callback = callback
//        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeout), target: self, selector: #selector(self.timeout), userInfo: nil, repeats: false)
//        centralManager.connect(peripheral, options: nil)
//    }
//
//    @objc func timeout() {
//        print("ConnectableDevice timeout")
//        callback?(.timeout)
//        cancelTimer()
//    }
//
//    @objc func cancelTimer() {
//        timer = nil
//        callback = nil
//    }
}
