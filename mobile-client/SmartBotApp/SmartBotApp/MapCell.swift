//
//  MapCell.swift
//  SmartBotApp
//
//  Created by Leonardo Ciocan on 28/02/2016.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit
import Charts

class MapCell: UITableViewCell {

    
    @IBOutlet weak var barChart: BarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    var months: [String]!
    func setCode(m : Message){
        months = m.labels
        let unitsSold = m.values
        
        setChart(months, values: unitsSold!,color: Core.colors[Core.currentService]!)
    }
    
    
    func setChart(dataPoints: [String], values: [Double] , color : UIColor) {
        self.barChart.noDataText = "You need to provide data for the chart."
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        chartDataSet.colors = [color]

        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        barChart.data = chartData
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInExpo)
    }
}
