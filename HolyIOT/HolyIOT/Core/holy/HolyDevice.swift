//
//  HolyDevice.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.01.18.
//

import CoreBluetooth

protocol HolyDeviceProtocol: NSObjectProtocol {
    func holyDevice(_ holyDevice: HolyDevice, didReceiveAccData data: AccelerometerData)
    func holyDevice(_ holyDevice: HolyDevice, didReceiveGyroData data: GyroscopeData)
    func holyDevice(_ holyDevice: HolyDevice, didReceiveMagnetoData data: MagnetometerData)
    func holyDevice(_ holyDevice: HolyDevice, didReceiveBarometerValue value: Int)
    func holyDevice(_ holyDevice: HolyDevice, didReceiveHumidityValue value: Float)
    func holyDevice(_ holyDevice: HolyDevice, didReceiveTemperatureValue value: Float)
    func holyDevice(_ holyDevice: HolyDevice, didReceiveSFLData data: SFLData)
    func connected(_ holyDevice: HolyDevice)
    func disconnected(_ holyDevice: HolyDevice)
}

class HolyDevice: Device {
    
    fileprivate var accelerometerRange: AccelerometerRange = AccelerometerRange.ACC_2G
    
    fileprivate var gyroscopeRange: GyroscopeRange = GyroscopeRange.GYRO_2000
    
    weak var delegate: HolyDeviceProtocol?
    
    override func connected() {
        super.connected()
        delegate?.connected(self)
    }
    
    override func disconnected() {
        super.disconnected()
        delegate?.disconnected(self)
    }
    
    override func discoverSensor(_ sensor: Sensor) {
    }
    
    override func didUpdateValueFor(_ sensor: Sensor) {
        switch sensor.sensorType {
        case .accelerometer:
            delegate?.holyDevice(self, didReceiveAccData: sensor.fetchAccelerometerData(accelerometerRange))
            break
        case .gyroscope:
            delegate?.holyDevice(self, didReceiveGyroData: sensor.fetchGyroscopeData(gyroscopeRange))
            break
        case .magnetometer:
            delegate?.holyDevice(self, didReceiveMagnetoData: sensor.magnetometerData)
            break
        case .barometer:
            delegate?.holyDevice(self, didReceiveBarometerValue: sensor.barometerData)
            break
        case .humidity:
            delegate?.holyDevice(self, didReceiveHumidityValue: sensor.humidityData)
            break
        case .temperature:
            delegate?.holyDevice(self, didReceiveTemperatureValue: sensor.temperatureData)
            break
        case .sfl:
            delegate?.holyDevice(self, didReceiveSFLData: sensor.sflData)
            break
        case .status:
            break
        case .powerAnswer:
            break
        default:
            break
        }
    }
}
