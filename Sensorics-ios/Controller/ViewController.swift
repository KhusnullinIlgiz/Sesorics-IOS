//
//  ViewController.swift
//  Sensorics-ios
//
//  Created by Ilgiz Khusnullin on 22.05.20.
//  Copyright © 2020 Ilgiz Khusnullin. All rights reserved.
//

import UIKit
import CoreBluetooth

//used for mainTableView and popupTableView
class BeaconsViewControllerCell: UITableViewCell{
    @IBOutlet weak var mainCellLable: UILabel!
    @IBOutlet weak var mainCellImageView: UIImageView!
    @IBOutlet weak var popupCellLable: UILabel!
}

class ViewController: UIViewController  {
    
    var centralManager: CBCentralManager!
    var beaconManager = BeaconManager()
    var periferalsArray = [BeaconModel]()
    var chosenPeriferalsArray = [BeaconModel]()
    var chosenPeriferal: String = ""
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var popupTableView: UITableView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var indicatorSpin: UIActivityIndicatorView!
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var foundDevice: UILabel!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.systemOrange //navigation bar to orange color
        beaconManager.delegate = self
        popupTableView.dataSource = self
        popupTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        blurView.bounds = self.view.bounds
        blurView.backgroundColor = .darkGray
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.35)
        popupView.layer.cornerRadius = popupView.frame.height / 15
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults"{
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.periferalId = chosenPeriferal
        }
    }
    
    
    
    }



//MARK: - CBCentralManagerDelegate

extension ViewController: CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn{
            print("BLE powered on")
            
            central.scanForPeripherals(withServices: nil, options: nil)
        }else{
            print("Error!")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let data = advertisementData["kCBAdvDataManufacturerData"] as? NSData{
            let publicData = Data(bytes: data.bytes, count: Int(data.length))
            let publicDataAsHexString = publicData.dataToHexString
            beaconManager.fetchData(data: publicDataAsHexString, periferal: peripheral.identifier.uuidString)
            
        }
    
       
        
        }
    
}

extension Data {
var dataToHexString: String {
    return reduce("") {$0 + String(format: "%02x", $1)}
}
}


//MARK: - BaconManagerDelegate

extension ViewController: BaconManagerDelegate{
 
    
    func didUpdateLabelsFirstPacket(beaconData: BeaconDataFirstPacket) {
        print("")
    }
    
    func didUpdateLabelsSecondPacket(beaconData: BeaconDataSecondPacket) {
        print("")
    }
        
    func didUpdateValue(periferals: [BeaconModel]){
        DispatchQueue.main.async {
            self.periferalsArray = periferals
            if !self.periferalsArray.isEmpty{
                self.foundDevice.isHidden = true
            }
            
            if !self.chosenPeriferalsArray.isEmpty{
                self.deviceLabel.isHidden = true
                for n in self.chosenPeriferalsArray{
                    if self.periferalsArray.contains(n){
                        self.periferalsArray.remove(at: self.periferalsArray.firstIndex(of: n)!)
                    }
                }
                
                if self.periferalsArray.isEmpty{
                    self.foundDevice.isHidden = false
                }
            }
            
            self.mainTableView.reloadData()
            self.popupTableView.reloadData()
            

        }
    }
    
    func didFailWithError(){
        
    }
    
    
}

//MARK: - Table View Update
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        if tableView == mainTableView{
            return chosenPeriferalsArray.count
        }else{
            return periferalsArray.count
        }
            
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == mainTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! BeaconsViewControllerCell
            let beaconName = chosenPeriferalsArray[indexPath.row]
            cell.mainCellLable?.text = beaconName.beaconName

                       return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: K.popupViewCellIdentifier, for: indexPath) as! BeaconsViewControllerCell
            let beaconName = periferalsArray[indexPath.row]
            cell.popupCellLable?.text = beaconName.beaconName
                       
                       return cell
        }
       
    }
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == popupTableView{
            chosenPeriferalsArray.append(periferalsArray[indexPath.row])
        } else if tableView == mainTableView{
            if chosenPeriferalsArray[indexPath.row].beaconName == "acnSENSA"{
                chosenPeriferal = chosenPeriferalsArray[indexPath.row].beaconPeriferalId
                self.performSegue(withIdentifier: "goToResults", sender: self)
            }else{
                showToast(message: chosenPeriferalsArray[indexPath.row].beaconName + " is absent", font: .italicSystemFont(ofSize: 15.0))
            }
            
        }
    }
}

//MARK: - popupView animation
extension ViewController{
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
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        indicatorSpin.startAnimating()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        animateIn(desiredView: blurView)
        animateIn(desiredView: popupView)
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        centralManager.stopScan()
        indicatorSpin.stopAnimating()
        animateOut(desiredView: popupView)
        animateOut(desiredView: blurView)
    }
    
}

//MARK: - Toast message

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }


