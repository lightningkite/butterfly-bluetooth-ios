//
//  typealiases.swift
//  ButterflyBluetooth
//
//  Created by Joseph Ivie on 12/1/20.
//

import Foundation
import CoreBluetooth

public typealias BleResponseStatus = CBATTError.Code

public extension BleResponseStatus {
    var name: String {
        return "\(self)"
    }
}
