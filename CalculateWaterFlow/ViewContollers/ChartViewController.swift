//
//  ChartViewController.swift
//  CalculateWaterFlow
//
//  Created by Shiva Nayakanti on 14/06/19.
//  Copyright © 2019 Shiva Nayakanti. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    var streamFlowObject = StreamFlowData()
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lineChartEntry = [ChartDataEntry]()
        var yAxis = 0
        for i in 0..<self.streamFlowObject.streamValues!.count{
            yAxis += 150
            let value = ChartDataEntry(x: self.streamFlowObject.streamValues![i], y:Double(yAxis))
            lineChartEntry.append(value)
        }
        
        //create a dataset with the streamflow values
        var streamFlowLine = LineChartDataSet(values: lineChartEntry, label: "Stream Value")
        streamFlowLine.colors = [UIColor.blue]
        
        //add the dataset to the line chart data
        let data = LineChartData()
        data.addDataSet(streamFlowLine)
        
        lineChartView.data = data

    }
}
