//
//  PressureLineChartViewController.swift
//  Sensorics-ios
//
//  Created by Ilgiz Khusnullin on 02.06.20.
//  Copyright © 2020 Ilgiz Khusnullin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Charts

class PressureLineChartViewController: UIViewController, ChartViewDelegate {
    
    var pressureArray: [Double] = []
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
        if !self.pressureArray.isEmpty{
            self.pressureArray.removeAll()
        }
        let realm = try! Realm()
        let results = realm.objects(SecondPacketRealm.self)
        for oblect in results{
            self.pressureArray.append(Double(oblect.pressureArrayData))
        }
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<self.pressureArray.count{

            let dataEntry = ChartDataEntry(x: Double(i), y: self.pressureArray[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Pressure " + K.presUnit)
        chartDataSet.lineWidth = 1.5
        chartDataSet.setColor(.red)
        chartDataSet.drawCirclesEnabled = false
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        lineChart.data = chartData
        
        
    }
    
}
