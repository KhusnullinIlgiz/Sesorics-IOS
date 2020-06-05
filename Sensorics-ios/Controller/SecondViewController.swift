//
//  SecondViewController.swift
//  Sensorics-ios
//
//  Created by Ilgiz Khusnullin on 22.05.20.
//  Copyright © 2020 Ilgiz Khusnullin. All rights reserved.
//

import Foundation

import UIKit
import CoreBluetooth
import RealmSwift
class SecondViewController: UIViewController {
    
    var centralManager: CBCentralManager!
    var beaconManager = BeaconManager()
    
    var periferalId: String = ""
    var flagScanPressed = false
    
    
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var accelerometerXLabel: UILabel!
    @IBOutlet weak var accelerometerYLabel: UILabel!
    @IBOutlet weak var accelerometerZLabel: UILabel!
    @IBOutlet weak var magnetometerXLabel: UILabel!
    @IBOutlet weak var magnetometerYLabel: UILabel!
    @IBOutlet weak var magnetometerZLabel: UILabel!
    @IBOutlet weak var gyroscopXLabel: UILabel!
    @IBOutlet weak var gyroscopYLabel: UILabel!
    @IBOutlet weak var gyroscopZLabel: UILabel!
    @IBOutlet weak var batteryLevelLabel: UILabel!
    
    @IBOutlet weak var firstLeft: UIView!
    @IBOutlet weak var firstRight: UIView!
    @IBOutlet weak var secondLeft: UIView!
    @IBOutlet weak var secondRight: UIView!
    @IBOutlet weak var thirdLeft: UIView!
    @IBOutlet weak var thirdRight: UIView!
    @IBOutlet weak var fourthLeft: UIView!
    @IBOutlet weak var fourthRight: UIView!
    @IBOutlet weak var fifthLeft: UIView!
    @IBOutlet weak var fifthRight: UIView!
    @IBOutlet weak var sixthLeft: UIView!
    @IBOutlet weak var sixthRight: UIView!
    @IBOutlet weak var seventhLeft: UIView!
    @IBOutlet weak var seventhRight: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var firstLeftImageView: UIImageView!
    

    @IBOutlet weak var firstLayer: UIView!
    @IBOutlet weak var startStopButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        
  
        
        let realm = try! Realm()
        try! realm.write{
            realm.deleteAll()
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.systemOrange
        navigationItem.setHidesBackButton(true, animated: true)
        startStopButton.isEnabled = false
        blurView.bounds = view.bounds
        blurView.backgroundColor = .darkGray
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.2)
        popupView.layer.cornerRadius = popupView.frame.height / 15
        
        beaconManager.delegate = self
        
        firstLeft.applyDesign()
        firstRight.applyDesign()
        secondLeft.applyDesign()
        secondRight.applyDesign()
        thirdLeft.applyDesign()
        thirdRight.applyDesign()
        fourthLeft.applyDesign()
        fourthRight.applyDesign()
        fifthLeft.applyDesign()
        fifthRight.applyDesign()
        sixthLeft.applyDesign()
        sixthRight.applyDesign()
        seventhLeft.applyDesign()
        seventhRight.applyDesign()
        animateIn(desiredView: blurView)
        animateIn(desiredView: popupView)
        
        
        
    }
    
    
    @IBAction func firstLeftPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToTempChart", sender: self)
    }
    
    @IBAction func firstRightPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToLightChart", sender: self)
    }
    
    @IBAction func secondLeftPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToPressureChart", sender: self)
    }
    
    @IBAction func secondRightPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToHumidityChart", sender: self)
    }
    
    @IBAction func thirdLeftPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToAccelChart", sender: self)
    }
    @IBAction func thirdRightPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToAccelChart", sender: self)
    }
    @IBAction func fourthLeftPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToAccelChart", sender: self)
    }
    @IBAction func fourthRightPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToMagnChart", sender: self)
    }
    @IBAction func fifthLeftPressed(_ sender: UIButton) {
         self.performSegue(withIdentifier: "GoToMagnChart", sender: self)
    }
    @IBAction func fifthRightPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToMagnChart", sender: self)
    }
    @IBAction func sixthLeftPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToGyroChart", sender: self)
    }
    @IBAction func sixthRightPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToGyroChart", sender: self)
    }
    @IBAction func seventhLeftPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToGyroChart", sender: self)
    }
    @IBAction func seventhRightPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToBatteryChart", sender: self)
    }
    @IBAction func scanPressed(_ sender: UIBarButtonItem) {
        if flagScanPressed{
            centralManager = CBCentralManager(delegate: self, queue: nil)
            flagScanPressed = false
            startStopButton.title = "Stop Scan"
        }else{
            centralManager.stopScan()
            flagScanPressed = true
            startStopButton.title = "Start Scan"
            
        }
        
    }
    
    
    @IBAction func yesPressed(_ sender: UIButton) {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        animateOut(desiredView: popupView)
        animateOut(desiredView: blurView)
        startStopButton.isEnabled = true
        flagScanPressed = false
        startStopButton.title = "Stop Scan"
    }
    
    
    @IBAction func noPressed(_ sender: UIButton) {
        
        animateOut(desiredView: popupView)
        animateOut(desiredView: blurView)
        startStopButton.isEnabled = true
        flagScanPressed = true
        startStopButton.title = "Start Scan"
        
       
    }
}



//MARK: - CBCentralManagerDelegate

extension SecondViewController: CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn{
            print("BLE powered on")
            
            central.scanForPeripherals(withServices: nil, options: nil)
        }else{
            print("Error!")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.identifier.uuidString ==  periferalId{
            if let data = advertisementData["kCBAdvDataManufacturerData"] as? NSData{
                let publicData = Data(bytes: data.bytes, count: Int(data.length))
                let publicDataAsHexString = publicData.dataToHexString
                
                beaconManager.fetchData(data: publicDataAsHexString)
            }
        }
        
        
        
        
    }
    
}




//MARK: - BaconManagerDelegate

extension SecondViewController: BaconManagerDelegate{
    func didUpdateValue(periferals: [BeaconModel]) {
        print("")
    }
    
    func didUpdateLabelsFirstPacket(beaconData: BeaconDataFirstPacket) {
        accelerometerXLabel.text = beaconData.accelerometer_X_String
        accelerometerYLabel.text = beaconData.accelerometer_Y_String
        accelerometerZLabel.text = beaconData.accelerometer_Z_String
        magnetometerXLabel.text = beaconData.magnetometer_X_String
        magnetometerYLabel.text = beaconData.magnetometer_Y_String
        magnetometerZLabel.text = beaconData.magnetometer_Z_String
        gyroscopXLabel.text = beaconData.giro_X_String
        gyroscopYLabel.text = beaconData.giro_Y_String
        gyroscopZLabel.text = beaconData.giro_Z_String
        
        let realm = try! Realm()
        let dataFirstPacketRealm = FirstPacketRealm() //used for Realm DB
        dataFirstPacketRealm.accelXArrayData = beaconData.accelerometer_X
        dataFirstPacketRealm.accelYArrayData = beaconData.accelerometer_Y
        dataFirstPacketRealm.accelZArrayData = beaconData.accelerometer_Z
        dataFirstPacketRealm.magnXArrayData = beaconData.magnetometer_X
        dataFirstPacketRealm.magnYArrayData = beaconData.magnetometer_Y
        dataFirstPacketRealm.magnZArrayData = beaconData.magnetometer_Z
        dataFirstPacketRealm.gyroXArrayData = beaconData.giro_X
        dataFirstPacketRealm.gyroYArrayData = beaconData.giro_Y
        dataFirstPacketRealm.gyroZArrayData = beaconData.giro_Z
        
        try! realm.write {
            realm.add(dataFirstPacketRealm)
        }
        
    
    }
    
    func didUpdateLabelsSecondPacket(beaconData: BeaconDataSecondPacket) {
        temperatureLabel.text = beaconData.temperature_String
        lightLabel.text = beaconData.light_String
        pressureLabel.text = beaconData.pressure_String
        humidityLabel.text = beaconData.humidity_String
        batteryLevelLabel.text = beaconData.battery_String
        
        let realm = try! Realm()
        let dataSecondPacketRealm = SecondPacketRealm()
        dataSecondPacketRealm.temperatureArrayData = beaconData.temp
        dataSecondPacketRealm.lightArrayData = beaconData.light
        dataSecondPacketRealm.pressureArrayData = beaconData.pressure
        dataSecondPacketRealm.humidityArrayData = beaconData.humidity
        dataSecondPacketRealm.batteryArrayData = beaconData.battery
    
        try! realm.write {
            realm.add(dataSecondPacketRealm)
        }
        

        
        
    }
    
    
    func didFailWithError(){
        
    }
}

//MARK: - UIView design
extension UIView{
    func applyDesign(){
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

//MARK: - PopupAnimation
extension SecondViewController{
    func animateIn(desiredView: UIView){
        let backgroundView = self.view!
        backgroundView.insertSubview(desiredView, aboveSubview: .init())
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center


        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            if desiredView == self.popupView{
                desiredView.alpha = 1
            }else{
                desiredView.alpha = 0.5
            }
            
        })
    }
    
    func animateOut(desiredView: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
}

