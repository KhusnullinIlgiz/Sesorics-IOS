//
//  GyroLineChartViewController.swift
//  Sensorics-ios
//
//  Created by Ilgiz Khusnullin on 02.06.20.
//  Copyright © 2020 Ilgiz Khusnullin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Charts

class GyroLineChartViewController: UIViewController, ChartViewDelegate {
    
    var gyro_X_Array: [Double] = []
    var gyro_Y_Array: [Double] = []
    var gyro_Z_Array: [Double] = []
    var lineChart = LineChartView()
    
    override func viewDidLoad() {
        lineChart.delegate = self
        
        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        lineChart.center = view.center
        lineChart.rightAxis.enabled = false
        //lineChart.xAxis.enabled = false

        view.addSubview(lineChart)
        self.didUpdateValue()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.didUpdateValue()
        })
        
    }
    
    
    func didUpdateValue(){
        if !self.gyro_X_Array.isEmpty || !self.gyro_Y_Array.isEmpty || !self.gyro_Z_Array.isEmpty{
            self.gyro_X_Array.removeAll()
            self.gyro_Y_Array.removeAll()
            self.gyro_Z_Array.removeAll()
        }
        let realm = try! Realm()
        let results = realm.objects(FirstPacketRealm.self)
        let data = LineChartData()
        for oblect in results{
            self.gyro_X_Array.append(Double(oblect.gyroXArrayData))
            self.gyro_Y_Array.append(Double(oblect.gyroYArrayData))
            self.gyro_Z_Array.append(Double(oblect.gyroZArrayData))
        }
        
        
        
        var dataEntriesLine1: [ChartDataEntry] = []
        var dataEntriesLine2: [ChartDataEntry] = []
        var dataEntriesLine3: [ChartDataEntry] = []
        for i in 0..<self.gyro_X_Array.count{

            let dataEntry = ChartDataEntry(x: Double(i), y: self.gyro_X_Array[i])
            dataEntriesLine1.append(dataEntry)
        }
        
        for i in 0..<self.gyro_Y_Array.count{

            let dataEntry = ChartDataEntry(x: Double(i), y: self.gyro_Y_Array[i])
            dataEntriesLine2.append(dataEntry)
        }
        
        for i in 0..<self.gyro_Z_Array.count{

            let dataEntry = ChartDataEntry(x: Double(i), y: self.gyro_Z_Array[i])
            dataEntriesLine3.append(dataEntry)
        }
        
        
        let chartDataSet1 = LineChartDataSet(entries: dataEntriesLine1, label: "Gyroscope X " + K.giroUnit)
        chartDataSet1.lineWidth = 1.5
        chartDataSet1.setColor(.red)
        chartDataSet1.drawCirclesEnabled = false
        let chartData1 = LineChartData(dataSet: chartDataSet1)
        chartData1.setDrawValues(false)
        data.addDataSet(chartDataSet1)
        
        let chartDataSet2 = LineChartDataSet(entries: dataEntriesLine2, label: "Gyroscope Y " + K.giroUnit)
        chartDataSet2.lineWidth = 1.5
        chartDataSet2.setColor(.green)
        chartDataSet2.drawCirclesEnabled = false
        let chartData2 = LineChartData(dataSet: chartDataSet2)
        chartData2.setDrawValues(false)
        data.addDataSet(chartDataSet2)
        
        let chartDataSet3 = LineChartDataSet(entries: dataEntriesLine3, label: "Gyroscope Z " + K.giroUnit)
        chartDataSet3.lineWidth = 1.5
        chartDataSet3.setColor(.blue)
        chartDataSet3.drawCirclesEnabled = false
        let chartData3 = LineChartData(dataSet: chartDataSet3)
        chartData3.setDrawValues(false)
        data.addDataSet(chartDataSet3)
        
        
        
        
        
        lineChart.data = data
    }
    
}
