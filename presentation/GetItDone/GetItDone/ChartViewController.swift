//
//  ChartViewController.swift
//  GetItDone
//
//  Created by Saarath Rathee on 2023-12-02.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and set up the line chart view
        lineChartView = LineChartView()
        lineChartView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300)
        lineChartView.center = view.center
        view.addSubview(lineChartView)
        
        // Set dummy data
        setData()
    }
    
    func setData() {
        // Create 10 dummy data points
        let values: [Double] = (0..<10).map { _ in Double.random(in: 0...100) }
        
        // Convert data points to ChartDataEntry objects
        let dataEntries = values.enumerated().map { ChartDataEntry(x: Double($0.offset), y: $0.element) }
        
        // Create a DataSet
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Dummy Data")
        dataSet.colors = [NSUIColor.blue]
        dataSet.valueColors = [NSUIColor.black]
        
        // Set the data
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
    }
}

