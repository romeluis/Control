//
//  PercentLineChart.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-03-01.
//

import SwiftUI

public struct LineChartView: View {
    var chart: LineChart

    public init(chart: LineChart) {
        self.chart = chart
    }

    public var body: some View {
            VStack() {
                HStack(spacing: 0) {
                    // Y-axis labels
                    VStack (alignment: .trailing) {
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 10)
                        ForEach(0..<chart.yAxisLabels.count, id: \.self) { index in
                            Text(chart.yAxisLabels[index])
                                .smallText()
                                .frame(height: 20)
                            if index != chart.yAxisLabels.count - 1 {
                                Spacer()
                            }
                        }
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 29)
                    }
                    .padding(.trailing, 5)
                    .frame(width: 40, alignment: .trailing)
                    
                    // Drawing Area
                    GeometryReader { outerGeo in
                        ScrollView (.horizontal) {
                            VStack {
                                ZStack {
                                    // Y-axis gridlines
                                    VStack {
                                        Rectangle()
                                            .fill(.clear)
                                            .frame(height: 10)
                                        ForEach(0..<chart.yAxisLabels.count, id: \.self) { index in
                                            HorizontalDivider(colour: Color("UI White"), width: index % 2 == 0 ? 2 : 1)
                                                .frame(height: 20)
                                            if index != chart.yAxisLabels.count - 1 {
                                                Spacer()
                                            }
                                        }
                                        Rectangle()
                                            .fill(.clear)
                                            .frame(height: 10)
                                    }
                                    .zIndex(0)
                                    
                                    // X-axis gridlines
                                    HStack {
                                        Rectangle()
                                            .fill(.clear)
                                            .frame(width: 10)
                                        ForEach(0..<chart.xAxisLabels.count, id: \.self) { index in
                                            VerticalDivider(colour: Color("UI White"))
                                                .frame(width: 12)
                                            if index != chart.xAxisLabels.count - 1 {
                                                Spacer()
                                            }
                                        }
                                        Rectangle()
                                            .fill(.clear)
                                            .frame(width: 10)
                                    }
                                    .zIndex(0)
                                    
                                    // Datapoints and connecting lines
                                    GeometryReader { geo in
                                        let availableWidth = geo.size.width  // full drawing area width
                                        let availableHeight = geo.size.height // full drawing area height
                                        let dataCount = chart.dataPoints.count
                                        let spacing = dataCount > 1 ? availableWidth / CGFloat(dataCount - 1) : availableWidth / 2
                                        
                                        // Draw each line segment with the endpoint's colour
                                        ForEach(0..<max(dataCount - 1, 0), id: \.self) { index in
                                            let startPoint = chart.dataPoints[index]
                                            let endPoint = chart.dataPoints[index + 1]
                                            let startX = spacing * CGFloat(index)
                                            let startY = availableHeight * (1 - CGFloat(startPoint.y) / 100)
                                            let endX = spacing * CGFloat(index + 1)
                                            let endY = availableHeight * (1 - CGFloat(endPoint.y) / 100)
                                            
                                            AnimatablePath(
                                                start: CGPoint(x: startX, y: startY),
                                                end: CGPoint(x: endX, y: endY)
                                            )
                                            // For geometry, SwiftUI will interpolate start and end points.
                                            .stroke(endPoint.colour, lineWidth: 4)
                                        }
                                        
                                        // Draw circles at each datapoint
                                        ForEach(Array(chart.dataPoints.enumerated()), id: \.offset) { index, point in
                                            let x = spacing * CGFloat(index)
                                            let y = availableHeight * (1 - CGFloat(point.y) / 100)
                                            Circle()
                                                .fill(point.colour)
                                                .stroke(Color("UI White"), lineWidth: 4)
                                                .frame(width: 15, height: 15)
                                                .position(x: x, y: y)
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 28)
                                    .zIndex(1)
                                }
                                .frame(minHeight: 250)
                                .backgroundFill(cornerRadius: 10, colour: Color("UI Light 1"))
                                
                                // X-axis labels
                                HStack {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(width: 10, height: 1)
                                    ForEach(0..<chart.xAxisLabels.count, id: \.self) { index in
                                        Text(chart.xAxisLabels[index])
                                            .smallText()
                                            .frame(width: 13)
                                        if index != chart.xAxisLabels.count - 1 {
                                            Spacer()
                                        }
                                    }
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(width: 10, height: 1)
                                }
                            }
                            .frame(minWidth: outerGeo.size.width)
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize, axes: [.horizontal])
                    .cornerRadius(10)
                }
            }
    }
}

#Preview {
    @Previewable let sampleChart = LineChart(
            dataPoints: [
                DataPoint(x: 1, y: 75, colour: Color("Purple Base")),
                DataPoint(x: 2, y: 50, colour: Color("Purple Base")),
                DataPoint(x: 3, y: 90, colour: Color("Purple Base")),
                DataPoint(x: 4, y: 25, colour: Color("AccentColor")),
                DataPoint(x: 5, y: 90, colour: Color("Purple Base")),
                DataPoint(x: 6, y: 80, colour: Color("Purple Base")),
                DataPoint(x: 7, y: 95, colour: Color("Purple Base")),
                DataPoint(x: 8, y: 45, colour: Color("Purple Base")),
                DataPoint(x: 9, y: 30, colour: Color("Purple Base")),
                DataPoint(x: 10, y: 70, colour: Color("Purple Base")),
                DataPoint(x: 11, y: 97, colour: Color("Purple Base")),
                DataPoint(x: 12, y: 33, colour: Color("Purple Base")),
                DataPoint(x: 13, y: 99, colour: Color("Purple Base"))
            ],
            title: "Performance Over Time",
            xAxisLabels: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"],
            yAxisLabels: ["100%", "75%", "50%", "25%", "0%"]
        )
    @Previewable let sampleChart1 = LineChart(
            dataPoints: [
                DataPoint(x: 1, y: 75, colour: Color("Purple Base")),
                DataPoint(x: 2, y: 50, colour: Color("Purple Base")),
                DataPoint(x: 3, y: 90, colour: Color("Purple Base")),
                DataPoint(x: 4, y: 25, colour: Color("AccentColor")),
                DataPoint(x: 5, y: 90, colour: Color("Purple Base")),
                DataPoint(x: 6, y: 80, colour: Color("Purple Base")),
                DataPoint(x: 7, y: 95, colour: Color("Purple Base")),
                DataPoint(x: 8, y: 45, colour: Color("Purple Base")),
                DataPoint(x: 9, y: 30, colour: Color("Purple Base")),
                DataPoint(x: 10, y: 70, colour: Color("Purple Base")),
                DataPoint(x: 11, y: 97, colour: Color("Purple Base")),
                DataPoint(x: 12, y: 33, colour: Color("Purple Base")),
                DataPoint(x: 13, y: 99, colour: Color("Purple Base"))
            ],
            title: "Performance Over Time",
            xAxisLabels: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"],
            yAxisLabels: ["100%", "75%", "50%", "25%", "0%"]
        )
        
    VStack {
        LineChartView(chart: sampleChart)
            .padding()
        LineChartView(chart: sampleChart1)
            .padding()
    }
}

