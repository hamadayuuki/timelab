//
//  DoneContentsChartView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/01.
//

import UIKit
import Charts

class DoneContentsChartView: PieChartView {
    let dataList = [
        (value: 10.0, label: "A", icon: UIImage(named: "Flask")),
        (value: 20.0, label: "B", icon: UIImage(named: "Lupe")),
        (value: 30.0, label: "C", icon: UIImage(named: "PencilAndEraser")),
        (value: 20.0, label: "D", icon: UIImage(named: "PencileAndNote")),
        (value: 20.0, label: "E", icon: UIImage(named: "Television"))
    ]
    var dataEntries: [PieChartDataEntry]!
    
    init() {
        super.init(frame: .zero)
        
        self.dataEntries = []
        for i in 0..<dataList.count {
            self.dataEntries.append(PieChartDataEntry(value: dataList[i].value, label: dataList[i].label))
        }
        
        setupCharts()
    }
    
    func setupCharts() {
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = ChartColorTemplates.timesOfDay()   // [UIColor]
        dataSet.entryLabelFont = NSUIFont(name: NSUIFont.TextStyle.title1.rawValue, size: 100)
        dataSet.drawValuesEnabled = false
        self.data = PieChartData(dataSet: dataSet)
        
        self.rotationEnabled = false
        self.drawEntryLabelsEnabled = false
        self.legend.enabled = false
        self.drawHoleEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
