//
//  SeconPacketRealm.swift
//  Sensorics-ios
//
//  Created by Ilgiz Khusnullin on 29.05.20.
//  Copyright © 2020 Ilgiz Khusnullin. All rights reserved.
//

import Foundation
import RealmSwift

class SecondPacketRealm: Object{
    @objc dynamic var temperatureArrayData: Float = 0.0
    @objc dynamic var lightArrayData: Float = 0.0
    @objc dynamic var pressureArrayData: Float = 0.0
    @objc dynamic var humidityArrayData: Float = 0.0
    @objc dynamic var batteryArrayData: Int16 = 0
}
