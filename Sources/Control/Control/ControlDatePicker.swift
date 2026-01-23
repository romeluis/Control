//
//  ControlDatePicker.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-12.
//

import SwiftUI

public struct ControlDatePicker: View {
    var title: String = ""
    
    @Binding var input: Date
    var validStartDate: Date = .distantPast
    var validEndDate: Date = .distantFuture
    
    var includeDate: Bool = true
    var includeYear: Bool = true
    var includeTime: Bool = true

    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .Control.gray1
    var textColour: Color = .accentColor
    
    @State private var editView: Bool = false
    
    @State private var day: Int = 0
    @State private var month: Int = 0
    @State private var year: Int = 0
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    @State private var isInitializing: Bool = true

    @Namespace private var namespace
    
    public init(
        title: String = "",
        input: Binding<Date>,
        validStartDate: Date = .distantPast,
        validEndDate: Date = .distantFuture,
        includeDate: Bool = true,
        includeYear: Bool = true,
        includeTime: Bool = true,
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .Control.gray1,
        textColour: Color = .accentColor
    ) {
        self.title = title
        self._input = input
        self.validStartDate = validStartDate
        self.validEndDate = validEndDate
        self.includeDate = includeDate
        self.includeYear = includeYear
        self.includeTime = includeTime
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.textColour = textColour
    }
    
    private var numberOfDaysInMonth: Int {
        let calendar = Calendar.current
        // month is stored as 0...11 in UI; convert to 1...12 for DateComponents
        let monthIndex = (0...11).contains(month) ? month + 1 : input.get(.month)
        // pick an effective year: state year if included and non-zero, else from input
        let effectiveYear: Int = {
            if includeYear, year != 0 {
                return year
            } else {
                return input.get(.year)
            }
        }()
        var comps = DateComponents()
        comps.year = effectiveYear
        comps.month = monthIndex
        comps.day = 1
        // Build a date for the first day of that month/year
        let date = calendar.date(from: comps) ?? input
        // Ask calendar for the range of valid days in this month
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 31
    }
    
    // MARK: - Bounds computed from validStartDate / validEndDate
    
    private var startY: Int { validStartDate.get(.year) }
    private var endY: Int { validEndDate.get(.year) }
    private var startM: Int { validStartDate.get(.month) } // 1...12
    private var endM: Int { validEndDate.get(.month) }     // 1...12
    private var startD: Int { validStartDate.get(.day) }
    private var endD: Int { validEndDate.get(.day) }
    private var startH: Int { validStartDate.get(.hour) }
    private var endH: Int { validEndDate.get(.hour) }
    private var startMin: Int { validStartDate.get(.minute) }
    private var endMin: Int { validEndDate.get(.minute) }
    
    // Allowed years
    private var allowedYears: ClosedRange<Int> {
        // If no real bounds are provided, show today ± 20 years
        if validStartDate == .distantPast && validEndDate == .distantFuture {
            let currentYear = Date().get(.year)
            return (currentYear - 20)...(currentYear + 20)
        }
        // Otherwise compute from provided bounds
        let minY = min(startY, endY)
        let maxY = max(startY, endY)
        return minY...maxY
    }
    
    // Allowed months for the currently selected year (returned as 0...11 for UI)
    private var allowedMonthIndices: ClosedRange<Int> {
        guard includeDate else { return 0...11 }
        let selectedYear = includeYear ? (year != 0 ? year : input.get(.year)) : input.get(.year)
        if selectedYear == startY && selectedYear == endY {
            // Single year range
            let minM = min(startM, endM) - 1
            let maxM = max(startM, endM) - 1
            return max(0, minM)...min(11, maxM)
        } else if selectedYear == startY {
            return (startM - 1)...11
        } else if selectedYear == endY {
            return 0...(endM - 1)
        } else {
            return 0...11
        }
    }
    
    // Allowed days for the selected year/month (1-based)
    private var allowedDays: ClosedRange<Int> {
        guard includeDate else { return 1...31 }
        let selectedYear = includeYear ? (year != 0 ? year : input.get(.year)) : input.get(.year)
        let selectedMonth1to12 = (0...11).contains(month) ? month + 1 : input.get(.month)
        
        // days in this month/year
        let daysInMonth = numberOfDaysInMonth
        var lower = 1
        var upper = daysInMonth
        
        // Constrain against start
        if selectedYear == startY && selectedMonth1to12 == startM {
            lower = max(lower, startD)
        }
        // Constrain against end
        if selectedYear == endY && selectedMonth1to12 == endM {
            upper = min(upper, endD)
        }
        // Safety
        lower = max(1, lower)
        upper = min(daysInMonth, upper)
        if lower > upper {
            // No valid days; fall back to 1...1 to keep Picker stable
            return 1...1
        }
        return lower...upper
    }
    
    // Allowed hours for the selected Y/M/D (0...23)
    private var allowedHours: ClosedRange<Int> {
        guard includeTime else { return 0...23 }
        let selectedYear = includeYear ? (year != 0 ? year : input.get(.year)) : input.get(.year)
        let selectedMonth1to12 = includeDate ? ((0...11).contains(month) ? month + 1 : input.get(.month)) : input.get(.month)
        let selectedDay = includeDate ? (day != 0 ? day : input.get(.day)) : input.get(.day)
        
        var lower = 0
        var upper = 23
        
        let matchesStart = (selectedYear == startY && selectedMonth1to12 == startM && selectedDay == startD)
        let matchesEnd = (selectedYear == endY && selectedMonth1to12 == endM && selectedDay == endD)
        
        if matchesStart {
            lower = max(lower, startH)
        }
        if matchesEnd {
            upper = min(upper, endH)
        }
        if lower > upper {
            return 0...0
        }
        return lower...upper
    }
    
    // Allowed minutes for the selected Y/M/D/H (0...59)
    private var allowedMinutes: ClosedRange<Int> {
        guard includeTime else { return 0...59 }
        let selectedYear = includeYear ? (year != 0 ? year : input.get(.year)) : input.get(.year)
        let selectedMonth1to12 = includeDate ? ((0...11).contains(month) ? month + 1 : input.get(.month)) : input.get(.month)
        let selectedDay = includeDate ? (day != 0 ? day : input.get(.day)) : input.get(.day)
        let selectedHour = hour
        
        var lower = 0
        var upper = 59
        
        let matchesStart = (selectedYear == startY && selectedMonth1to12 == startM && selectedDay == startD && selectedHour == startH)
        let matchesEnd = (selectedYear == endY && selectedMonth1to12 == endM && selectedDay == endD && selectedHour == endH)
        
        if matchesStart {
            lower = max(lower, startMin)
        }
        if matchesEnd {
            upper = min(upper, endMin)
        }
        if lower > upper {
            return 0...0
        }
        return lower...upper
    }
    
    // Clamp current selections when bounds change
    private func clampSelectionsToBounds() {
        // Year
        if includeYear {
            if year < allowedYears.lowerBound { year = allowedYears.lowerBound }
            if year > allowedYears.upperBound { year = allowedYears.upperBound }
        } else {
            // Don't modify year when includeYear is false - preserve original
            year = input.get(.year)
        }
        // Month (0...11)
        if includeDate {
            if month < allowedMonthIndices.lowerBound { month = allowedMonthIndices.lowerBound }
            if month > allowedMonthIndices.upperBound { month = allowedMonthIndices.upperBound }
            // Day (1-based)
            if day < allowedDays.lowerBound { day = allowedDays.lowerBound }
            if day > allowedDays.upperBound { day = allowedDays.upperBound }
        } else {
            month = input.get(.month) - 1
            day = input.get(.day)
        }
        // Time
        if includeTime {
            if hour < allowedHours.lowerBound { hour = allowedHours.lowerBound }
            if hour > allowedHours.upperBound { hour = allowedHours.upperBound }
            if minute < allowedMinutes.lowerBound { minute = allowedMinutes.lowerBound }
            if minute > allowedMinutes.upperBound { minute = allowedMinutes.upperBound }
        } else {
            hour = input.get(.hour)
            minute = input.get(.minute)
        }
    }
    
    public var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            //Title of textfield if present
            if !title.isEmpty {
                Text(title)
                    .smallText()
                    .padding(.leading, 7)
            }
            
            VStack {
                //Edit view
                if editView {
                    HStack (spacing: 5) {
                        Spacer()
                        
                        if includeDate {
                            Menu {
                                Picker(selection: $month, label: EmptyView()) {
                                    ForEach(allowedMonthIndices, id: \.self) {
                                        Text(Calendar.current.monthSymbols[$0])
                                    }
                                }
                            } label: {
                                Text(Calendar.current.monthSymbols[min(max(month, 0), 11)])
                                    .bodyText()
                                    .matchedGeometryEffect(id: "month", in: self.namespace)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .backgroundFill(cornerRadius: 10, colour: outlineColour)
                            }
                                
                            HStack (spacing: 0) {
                                Menu {
                                    Picker(selection: $day, label: EmptyView()) {
                                        ForEach(allowedDays, id: \.self) {
                                            Text("\($0)")
                                        }
                                    }
                                } label: {
                                    Text("\(day)")
                                        .bodyText()
                                        .matchedGeometryEffect(id: "day", in: self.namespace)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .backgroundFill(cornerRadius: 10, colour: outlineColour)
                                }
                                if includeYear {
                                    Text(verbatim: ",")
                                        .bodyText()
                                        .matchedGeometryEffect(id: "extra", in: self.namespace)
                                }
                            }
                        }
                        
                        if includeYear {
                            HStack (spacing: 0) {
                                Menu {
                                    Picker(selection: $year, label: EmptyView()) {
                                        ForEach(allowedYears, id: \.self) {
                                            Text(verbatim: "\($0)")
                                        }
                                    }
                                } label: {
                                    Text(verbatim: "\(year)")
                                        .bodyText()
                                        .matchedGeometryEffect(id: "year", in: self.namespace)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .backgroundFill(cornerRadius: 10, colour: outlineColour)
                                }
                            }
                        }
                        
                        if includeTime {
                            HStack (spacing: 0) {
                                Menu {
                                    Picker(selection: $hour, label: EmptyView()) {
                                        ForEach(allowedHours, id: \.self) {
                                            Text(verbatim: "\($0)")
                                        }
                                    }
                                } label: {
                                    Text(String(format: "%02d", hour))
                                        .bodyText()
                                        .matchedGeometryEffect(id: "hour", in: self.namespace)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .backgroundFill(cornerRadius: 10, colour: outlineColour)
                                }
                                Text(":")
                                    .bodyText()
                                    .matchedGeometryEffect(id: "colon", in: self.namespace)
                                Menu {
                                    Picker(selection: $minute, label: EmptyView()) {
                                        ForEach(allowedMinutes, id: \.self) {
                                            Text(verbatim: String(format: "%02d", $0))
                                        }
                                    }
                                } label: {
                                    Text(String(format: "%02d", minute))
                                        .bodyText()
                                        .matchedGeometryEffect(id: "minute", in: self.namespace)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .backgroundFill(cornerRadius: 10, colour: outlineColour)
                                }
                            }
                        }
                        
                        Circle()
                            .stroke(lineWidth: 2)
                            .foregroundColor(textColour)
                            .frame(width: 8, height: 8)
                            .padding(.horizontal, 5)
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.3)) {
                                    editView = false
                                }
                            }
                    }
                    //Set View
                } else {
                    HStack (spacing: 5) {
                        Spacer()
                        
                        if includeDate {
                                Text(Calendar.current.monthSymbols[input.get(.month) - 1])
                                    .bodyText()
                                    .matchedGeometryEffect(id: "month", in: self.namespace)
                            HStack (spacing: 0) {
                                Text("\(input.get(.day))")
                                    .bodyText()
                                    .matchedGeometryEffect(id: "day", in: self.namespace)
                                if includeYear {
                                    Text(verbatim: ",")
                                        .bodyText()
                                        .matchedGeometryEffect(id: "extra", in: self.namespace)
                                }
                            }
                        }
                        
                        if includeYear {
                            HStack (spacing: 0) {
                                Text(verbatim: "\(input.get(.year))")
                                    .bodyText()
                                    .matchedGeometryEffect(id: "year", in: self.namespace)
                            }
                        }
                        
                        if includeTime {
                            HStack (spacing: 0) {
                                Text(String(format: "%02d", input.get(.hour)))
                                    .bodyText()
                                    .matchedGeometryEffect(id: "hour", in: self.namespace)
                                Text(":")
                                    .bodyText()
                                    .matchedGeometryEffect(id: "colon", in: self.namespace)
                                Text(String(format: "%02d", input.get(.minute)))
                                    .bodyText()
                                    .matchedGeometryEffect(id: "minute", in: self.namespace)
                            }
                        }
                        
                        Circle()
                            .fill(textColour)
                            .frame(width: 8, height: 8)
                            .padding(.horizontal, 5)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, editView ? 10 : 15)
            .backgroundStroke(cornerRadius: 20, colour: outlineColour)
            .backgroundFill(cornerRadius: 20, colour: backgroundColour)
            .onTapGesture {
                if !editView {
                    withAnimation(.spring(duration: 0.3)) {
                        editView = true
                    }
                }
            }
            .onChange(of: day + month + year + hour + minute) {
                // Skip updates during initialization to prevent unwanted writes
                guard !isInitializing else { return }
                clampSelectionsToBounds()
                updateInput()
            }
            .onAppear {
                isInitializing = true
                // Initialize state from the current input date
                if includeDate {
                    day = input.get(.day)
                    let m = input.get(.month) // 1...12
                    month = max(0, min(11, m - 1)) // convert to 0...11
                }
                if includeYear {
                    year = input.get(.year)
                }
                if includeTime {
                    hour = input.get(.hour)
                    minute = input.get(.minute)
                }
                // Clamp initial selections to bounds
                clampSelectionsToBounds()
                // Initialization complete - now allow updates
                isInitializing = false
            }
        }
    }
    
    func updateInput() {
        let calendar = Calendar.current
        
        // Build components from state, honoring which parts are included
        var comps = DateComponents()
        comps.calendar = calendar
        
        if includeYear {
            comps.year = year != 0 ? year : input.get(.year)
        } else {
            comps.year = input.get(.year)
        }
        
        if includeDate {
            // month is stored 0...11 in UI, convert to 1...12 for DateComponents
            let currentMonth = input.get(.month)
            let currentDay = input.get(.day)
            comps.month = (month >= 0 && month <= 11) ? (month + 1) : currentMonth
            comps.day = day != 0 ? day : currentDay
        } else {
            comps.month = input.get(.month)
            comps.day = input.get(.day)
        }
        
        if includeTime {
            comps.hour = hour
            comps.minute = minute
        } else {
            comps.hour = input.get(.hour)
            comps.minute = input.get(.minute)
        }
        
        // Preserve seconds if present, otherwise default to 0
        comps.second = input.get(.second)
        
        // Attempt to build a date
        let newDate = calendar.date(from: comps) ?? input
        
        // Clamp to valid range
        let clamped: Date
        if newDate < validStartDate {
            clamped = validStartDate
        } else if newDate > validEndDate {
            clamped = validEndDate
        } else {
            clamped = newDate
        }
        
        input = clamped
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var date: Date = Date()
    ScrollView {
        ControlDatePicker(title: "Date", input: $date)
        
        ControlDatePicker(title: "Date", input: $date, includeTime: false)
        ControlDatePicker(title: "Date", input: $date, includeDate: false)
        
        ControlDatePicker(title: "Date", input: $date, validStartDate: .now.addingTimeInterval(-100000000), validEndDate: .now.addingTimeInterval(1000))
        
        Text("\(date)")
    }
    .background(.fill)
}
