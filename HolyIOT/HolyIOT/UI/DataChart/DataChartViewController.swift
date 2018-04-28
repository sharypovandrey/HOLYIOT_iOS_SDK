//
//  DataChartViewController.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 29.04.2018.
//

import UIKit

class DataChartViewController: UIViewController {

    var device: HolyDevice!

    override func viewDidLoad() {
        super.viewDidLoad()

        let _ = device.turnOn()

        device.setNotifyValue(true, for: .sfl)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        device.delegate = self
    }
}

extension DataChartViewController: HolyDeviceProtocol {
    func holyDevice(_ holyDevice: HolyDevice, didReceiveAccData data: AccelerometerData) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveGyroData data: GyroscopeData) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveMagnetoData data: MagnetometerData) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveBarometerValue value: Int) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveHumidityValue value: Float) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveTemperatureValue value: Float) {

    }

    func connected(_ holyDevice: HolyDevice) {

    }

    func disconnected(_ holyDevice: HolyDevice) {

    }

    func holyDevice(_ holyDevice: HolyDevice, didReceiveSFLData data: SFLData) {

    }
}
