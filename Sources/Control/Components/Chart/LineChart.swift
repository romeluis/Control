//
//  LineChart.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-03-01.
//

public struct LineChart {
    var dataPoints: [DataPoint]
    
    var title: String
    var xAxisLabels: [String]
    var yAxisLabels: [String]
	
	public init(dataPoints: [DataPoint], title: String, xAxisLabels: [String], yAxisLabels: [String]) {
		self.dataPoints = dataPoints
		self.title = title
		self.xAxisLabels = xAxisLabels
		self.yAxisLabels = yAxisLabels
	}
}
