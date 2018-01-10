//
//  HolyAdvertisementData.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 09.01.18.
//

import UIKit
import CoreBluetooth

open class HolyAdvertisementData {
    
    static func nameForAdvertisementDataWithKey(_ key: String) -> String {
        switch key {
        case CBAdvertisementDataLocalNameKey:
            return "Local Name"
        case CBAdvertisementDataTxPowerLevelKey:
            return "Tx Power Level"
        case CBAdvertisementDataServiceUUIDsKey:
            return "Service UUIDs"
        case CBAdvertisementDataServiceDataKey:
            return "Service Data"
        case CBAdvertisementDataManufacturerDataKey:
            return "Manufacturer Data"
        case CBAdvertisementDataOverflowServiceUUIDsKey:
            return "Overflow Service UUIDs"
        case CBAdvertisementDataIsConnectable:
            return "Device is Connectable"
        case CBAdvertisementDataSolicitedServiceUUIDsKey:
            return "Solicited Service UUIDs"
        default:
            return "Unknown key"
        }
    }
    
    static func stringDictFromAdvertisementData(_ advertisementData: [String : Any]) -> [String : String] {
        var dict:[String : String] = [:]
        
        for data in advertisementData {
            var resultString : String?
            switch data.key {
            case CBAdvertisementDataLocalNameKey, CBAdvertisementDataTxPowerLevelKey:
                resultString = data.value as? String
                break
            case CBAdvertisementDataServiceUUIDsKey:
                if let serviceUUIDs = data.value as? NSArray {
                    resultString = serviceUUIDs.map({"\($0)"}).joined(separator: ", ")
                }
                break
            case CBAdvertisementDataServiceDataKey:
                if let serviceDataDict = data.value as? NSDictionary {
                    resultString = serviceDataDict.map({"\($0.key) \($0.value)"}).joined(separator: ", ")
                }
                break
            case CBAdvertisementDataManufacturerDataKey:
                resultString = (data.value as? Data)?.description
                break
            case CBAdvertisementDataIsConnectable:
                if let connectable = data.value as? NSNumber {
                    resultString = connectable.boolValue ? "true" : "false"
                }
                break
            default:
                break
            }
            dict[nameForAdvertisementDataWithKey(data.key)] = resultString ?? "no value"
        }
        
        return dict
    }
    
}
