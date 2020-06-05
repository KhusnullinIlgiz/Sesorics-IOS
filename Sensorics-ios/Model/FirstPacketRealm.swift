//
//  FirstPacketRealm.swift
//  Sensorics-ios
//
//  Created by Ilgiz Khusnullin on 29.05.20.
//  Copyright © 2020 Ilgiz Khusnullin. All rights reserved.
//

import Foundation
import RealmSwift

class FirstPacketRealm: Object{
    @objc dynamic var accelXArrayData: Float = 0.0
    @objc dynamic var accelYArrayData: Float = 0.0
    @objc dynamic var accelZArrayData: Float = 0.0
    @objc dynamic var magnXArrayData: Float = 0.0
    @objc dynamic var magnYArrayData: Float = 0.0
    @objc dynamic var magnZArrayData: Float = 0.0
    @objc dynamic var gyroXArrayData: Float = 0.0
    @objc dynamic var gyroYArrayData: Float = 0.0
    @objc dynamic var gyroZArrayData: Float = 0.0
}
