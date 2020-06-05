//
//  BeaconManager.swift
//  bluetoothExample
//
//  Created by Ilgiz Khusnullin on 19.05.20.
//  Copyright © 2020 Ilgiz Khusnullin. All rights reserved.
//
// Here covered only acnSENSA parameters: https://aconno.de//deserializer/0800.json
// To cover more interested parameters look Aconno documentationimport Foundation
import CoreBluetooth

protocol BaconManagerDelegate {
    func didUpdateValue(periferals: [BeaconModel])
    func didUpdateLabelsFirstPacket(beaconData: BeaconDataFirstPacket)
    func didUpdateLabelsSecondPacket(beaconData: BeaconDataSecondPacket)
    func didFailWithError()
    
}
struct BeaconManager {
    var periferals: [BeaconModel] = []
    var delegate: BaconManagerDelegate?
    
    
    
    
    
    
    mutating func fetchData(data: String){
        if let fetchedDataSecondPacket = performDeserialisationSecondPacket(data: data){
            delegate?.didUpdateLabelsSecondPacket(beaconData: fetchedDataSecondPacket)
        }
        if let fetchedDataFirstPacket = performDesirialisationFirstPacket(data: data){
            delegate?.didUpdateLabelsFirstPacket(beaconData: fetchedDataFirstPacket)
        }
        
    }
    
    mutating func fetchData(data: String, periferal: String){
        
        if data.contains(K.aconnoId) {
            let beaconModel = BeaconModel(beaconPeriferalId: periferal , beaconName: getBeaconName(data: data))
            if !periferals.contains(beaconModel){
                periferals.append(beaconModel)
            }
            delegate?.didUpdateValue(periferals: periferals)
        }
        
    }
    
    
    
    
    mutating func performDeserialisationSecondPacket(data: String) -> BeaconDataSecondPacket?{
        let dataArray = Array(data)
        
        if data.contains(K.aconnoId) && data.count == 48{
            
            
            let temp = String(dataArray[12...19]).unhexlify
            let hum = String(dataArray[20...27]).unhexlify
            let pres = String(dataArray[28...35]).unhexlify
            let light = String(dataArray[36...43]).unhexlify
            let battery = String(dataArray[44...47]).unhexlify
            
            let beackonDataSecondPacket = BeaconDataSecondPacket(temp: floatValue(data: temp), humidity: floatValue(data: hum), pressure: floatValue(data: pres), light: floatValue(data: light), battery: intValue(data: battery))
            return beackonDataSecondPacket
            
        }else{
            return nil
        }
        
    }
    
    func getBeaconName(data: String) -> String{
        let dataArray = Array(data)
        let id = String(dataArray[6...7])
        
        switch id {
        case K.finder_led_id:
            return "acnALERT"
        case K.button_id:
            return "acnACT"
        case K.sensa_id:
            return "acnSENSA"
        default:
            return "unknown device"
        }
    }
    
    func performDesirialisationFirstPacket(data: String) -> BeaconDataFirstPacket?{
        let dataArray = Array(data)
        if data.contains(K.aconnoId) && data.count == 50{
            let giro_X  = String(dataArray[12...15]).unhexlify
            let giro_Y  = String(dataArray[16...19]).unhexlify
            let giro_Z  = String(dataArray[20...23]).unhexlify
            
            let accelerometer_X  = String(dataArray[24...27]).unhexlify
            let accelerometer_Y  = String(dataArray[28...31]).unhexlify
            let accelerometer_Z  = String(dataArray[32...35]).unhexlify
            
            let magnetometer_X  = String(dataArray[36...39]).unhexlify
            let magnetometer_Y  = String(dataArray[40...43]).unhexlify
            let magnetometer_Z  = String(dataArray[44...47]).unhexlify
            
            let beaconDataFirstPacket = BeaconDataFirstPacket(giro_X: Float(intValue(data: giro_X)), giro_Y: Float(intValue(data: giro_Y)), giro_Z: Float(intValue(data: giro_Z)), accelerometer_X: Float(intValue(data: accelerometer_X)), accelerometer_Y: Float(intValue(data: accelerometer_Y)), accelerometer_Z: Float(intValue(data: accelerometer_Z)), magnetometer_X: Float(intValue(data: magnetometer_X)), magnetometer_Y: Float(intValue(data: magnetometer_Y)), magnetometer_Z: Float(intValue(data: magnetometer_Z)))
            return beaconDataFirstPacket
        }else{
            return nil
        }
    }
    
    
    func floatValue(data: Data) -> Float {
        
        return Float(bitPattern: UInt32(littleEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) }))
    }
    
    func intValue(data: Data) -> Int16{
        return Int16(bitPattern: UInt16(littleEndian: data.withUnsafeBytes { $0.load(as: UInt16.self) }))
    }
    
    
    
}


//MARK: - convertion String to HexString (Data format)
extension String {
    var unhexlify: Data {
        let length = self.count / 2
        var data = Data(capacity: length)
        for i in 0 ..< length {
            let j = self.index(self.startIndex, offsetBy: i * 2)
            let k = self.index(j, offsetBy: 2)
            let bytes = self[j..<k]
            if var byte = UInt8(bytes, radix: 16) {
                data.append(&byte, count: 1)
            }
        }
        return data
    }
    
}

