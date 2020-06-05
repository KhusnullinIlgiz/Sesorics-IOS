//
//  BeaconData.swift
//  bluetoothExample
//
//  Created by Ilgiz Khusnullin on 19.05.20.
//  Copyright © 2020 Ilgiz Khusnullin. All rights reserved.
//

// Here covered only acnSENSA parameters: https://aconno.de//deserializer/0800.json
// To cover more interested parameters look Aconno documentation
import Foundation

struct BeaconDataFirstPacket {
    let giro_X: Float
    let giro_Y: Float
    let giro_Z: Float
    let accelerometer_X: Float
    let accelerometer_Y: Float
    let accelerometer_Z: Float
    let magnetometer_X: Float
    let magnetometer_Y: Float
    let magnetometer_Z: Float
    
    
    
    var giro_X_String: String{
        return String(format: "%.2f", giro_X * K.giroParam) + K.giroUnit
    }
    
    var giro_Y_String: String{
        return String(format: "%.2f", giro_Y * K.giroParam) + K.giroUnit
    }
    
    var giro_Z_String: String{
        return String(format: "%.2f", giro_Z * K.giroParam) + K.giroUnit
    }
    
    
    var accelerometer_X_String: String{
        return String(format: "%.2f", accelerometer_X * K.accelParam) + K.accelunit
    }
    
    var accelerometer_Y_String: String{
        return String(format: "%.2f", accelerometer_Y * K.accelParam) + K.accelunit
    }
    
    var accelerometer_Z_String: String{
        return String(format: "%.2f", accelerometer_Z * K.accelParam) + K.accelunit
    }
    
    var magnetometer_X_String: String{
        return String(format: "%.2f", magnetometer_X * K.magnParam) + K.magnUnit
    }
    
    var magnetometer_Y_String: String{
        return String(format: "%.2f", magnetometer_Y * K.magnParam) + K.magnUnit
    }
    
    var magnetometer_Z_String: String{
        return String(format: "%.2f", magnetometer_Z * K.magnParam) + K.magnUnit
    }
    
    
    
    
}


struct BeaconDataSecondPacket {
    let temp: Float
    let humidity: Float
    let pressure: Float
    let light: Float
    let battery: Int16
    
    var temperature_String: String{
        return String(format: "%.2f", temp) + K.tempUnit
    }
    
    var humidity_String: String{
        return String(format: "%.2f", humidity) + K.humUnit
    }
    
    var pressure_String: String{
        return String(format: "%.2f", pressure) + K.presUnit
    }
    
    var light_String: String{
        return String(format: "%.2f", light) + K.lightUnit
    }
    
    var battery_String: String{
        return String(battery) + K.batteryUnit
    }
}
