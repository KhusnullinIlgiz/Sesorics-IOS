//
//  BeaconModel.swift
//  bluetoothExample
//
//  Created by Ilgiz Khusnullin on 19.05.20.
//  Copyright © 2020 Ilgiz Khusnullin. All rights reserved.
//

import Foundation

struct BeaconModel: Equatable {
    var beaconPeriferalId: String
    var beaconName: String
    
    static func ==(lhs: BeaconModel, rhs: BeaconModel) -> Bool {
        return lhs.beaconPeriferalId == rhs.beaconPeriferalId && lhs.beaconName == rhs.beaconName
    }
}

