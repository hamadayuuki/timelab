//
//  DoneContentsChartView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/01.
//

import UIKit
import Charts

class DoneContentsChartView: PieChartView {
    var dataEntries: [PieChartDataEntry]!
    var isAllNight: Bool!
    
    init(dataEntries: [PieChartDataEntry], isAllNight: Bool) {
        super.init(frame: .zero)
        
        self.dataEntries = dataEntries
        self.isAllNight = isAllNight
//        self.dataEntries = []
//        for data in dataList {
//            self.dataEntries.append((value: data.value, label: data.label))
//        }
        
        setupCharts()
    }
    
    func setupCharts() {
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        if isAllNight { dataSet.colors = ChartColorTemplates.timesOfDayAllNight() }   // [UIColor]
        else { dataSet.colors = ChartColorTemplates.timesOfDay() }
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
