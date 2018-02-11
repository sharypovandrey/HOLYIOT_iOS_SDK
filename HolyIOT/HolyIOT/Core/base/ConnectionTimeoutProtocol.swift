//
//  TimeoutProtocol.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 16.01.18.
//

import Foundation

enum ConnectionStatus {
    case connected
    case timeout
    case fail(Error?)
}

protocol ConnectionTimeoutProtocol: NSObjectProtocol {
    
    typealias ConnectionTimeoutClosure = (ConnectionStatus) -> Void
    
    typealias Seconds = Int
    
    func connect(timeout: Seconds, callback: @escaping ConnectionTimeoutClosure)
    
    func timeout()
    
    func cancelTimer()
}
