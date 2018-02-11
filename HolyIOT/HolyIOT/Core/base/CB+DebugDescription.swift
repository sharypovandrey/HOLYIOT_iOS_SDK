//
//  CBService+DebugDescription.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 16.01.18.
//

import CoreBluetooth

extension Device {
    open override var debugDescription: String {
//        let advString = advertisementData.map{"\n   \($0.key)=\($0.value)"}.joined(separator: ", ")
        let advString = advertisementData?.localName ?? "no local name"
        let servicesString = services.map { (service) -> String in
            return "\n  \(service.debugDescription)"
            }.joined(separator: ", ")
        return """
        id: \(id)
        rssi: \(rssi)
        state: \(state)
        advertisementData: \(advString)
        services: \(servicesString)
        """
    }
}

extension CBService {
    open override var debugDescription: String {
        let includedServicesString: String = includedServices?.map { (service) -> String in
            return "\n  \(service.debugDescription)"
            }.joined(separator: ", ") ?? "[]"
        let charsString: String = characteristics?.map {"\n    \($0.debugDescription)"}.joined(separator: ", ") ?? "[]"
        return """
        Suuid: \(uuid)
        SisPrimary: \(isPrimary)
        SincludedServices: \(includedServicesString)
        Scharacteristics: \(charsString)
        """
    }
}

extension CBCharacteristic {
    open override var debugDescription: String {
        let descrsString = descriptors?.map {"\n    \($0.debugDescription)"}.joined(separator: ", ") ?? "[]"
        return """
        Cuuid \(uuid)
        CisNotifying \(isNotifying)
        Cvalue \(value != nil)
        Cproperties \(properties)
        Cdescriptions \(descrsString)
        """
    }
}

extension CBDescriptor {
    open override var debugDescription: String {
        return """
        Dvalue \(value != nil)
        """
    }
}
