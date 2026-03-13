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

    // Calendar navigation
    @State private var displayedMonth: Int = 1  // 1...12
    @State private var displayedYear: Int = 2026
    @State private var navigateForward: Bool = true

    // Time state (always stored as 24H internally)
    @State private var hour: Int = 0
    @State private var minute: Int = 0

    @State private var isInitializing: Bool = true

    @Namespace private var namespace

    private let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols

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

    // MARK: - 12H / 24H Detection

    private var uses12HourFormat: Bool {
        let fmt = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current) ?? "HH"
        return fmt.contains("a")
    }

    // MARK: - 12H Display Helpers

    private var isEndOfDay: Bool {
        hour == 23 && minute == 59
    }

    /// Convert 24H hour (0-23) to 12H display hour (1-12).
    private func to12Hour(_ h: Int) -> Int {
        if h == 0 { return 12 }
        if h > 12 { return h - 12 }
        return h
    }

    private var isPM: Bool { hour >= 12 }

    /// Binding for the 12H hour picker (values 1-12).
    private var hour12Binding: Binding<Int> {
        Binding(
            get: { to12Hour(hour) },
            set: { newH in
                if isPM {
                    hour = newH == 12 ? 12 : newH + 12
                } else {
                    hour = newH == 12 ? 0 : newH
                }
            }
        )
    }

    /// Binding for the AM/PM picker (false = AM, true = PM).
    private var ampmBinding: Binding<Bool> {
        Binding(
            get: { isPM },
            set: { newPM in
                if newPM && !isPM {
                    hour = min(hour + 12, 23)
                } else if !newPM && isPM {
                    hour = max(hour - 12, 0)
                }
            }
        )
    }

    // MARK: - Allowed Years

    private var allowedYears: ClosedRange<Int> {
        if validStartDate == .distantPast && validEndDate == .distantFuture {
            let currentYear = Date().get(.year)
            return (currentYear - 20)...(currentYear + 20)
        }
        let minY = min(validStartDate.get(.year), validEndDate.get(.year))
        let maxY = max(validStartDate.get(.year), validEndDate.get(.year))
        return minY...maxY
    }

    private var allowedMonthsForDisplayedYear: ClosedRange<Int> {
        let startY = validStartDate.get(.year)
        let endY = validEndDate.get(.year)
        let startM = validStartDate.get(.month)
        let endM = validEndDate.get(.month)

        if displayedYear == startY && displayedYear == endY {
            return max(1, min(startM, endM))...min(12, max(startM, endM))
        } else if displayedYear == startY {
            return startM...12
        } else if displayedYear == endY {
            return 1...endM
        }
        return 1...12
    }

    // MARK: - Calendar Helpers

    private var daysInDisplayedMonth: Int {
        let cal = Calendar.current
        var comps = DateComponents()
        comps.year = displayedYear
        comps.month = displayedMonth
        comps.day = 1
        guard let date = cal.date(from: comps) else { return 31 }
        return cal.range(of: .day, in: .month, for: date)?.count ?? 31
    }

    private var firstWeekdayOffset: Int {
        let cal = Calendar.current
        var comps = DateComponents()
        comps.year = displayedYear
        comps.month = displayedMonth
        comps.day = 1
        guard let date = cal.date(from: comps) else { return 0 }
        return cal.component(.weekday, from: date) - 1
    }

    private var calendarCells: [Int?] {
        var cells: [Int?] = Array(repeating: nil, count: firstWeekdayOffset)
        cells += (1...daysInDisplayedMonth).map { Optional($0) }
        while cells.count % 7 != 0 { cells.append(nil) }
        return cells
    }

    private func isDayEnabled(_ day: Int) -> Bool {
        let cal = Calendar.current
        var comps = DateComponents()
        comps.year = includeYear ? displayedYear : input.get(.year)
        comps.month = displayedMonth
        comps.day = day
        comps.hour = 12
        guard let date = cal.date(from: comps) else { return false }
        let dayStart = cal.startOfDay(for: date)
        let validStart = cal.startOfDay(for: validStartDate)
        let validEnd = cal.startOfDay(for: validEndDate)
        return dayStart >= validStart && dayStart <= validEnd
    }

    private func isDaySelected(_ day: Int) -> Bool {
        guard displayedMonth == input.get(.month) else { return false }
        guard day == input.get(.day) else { return false }
        if includeYear { return displayedYear == input.get(.year) }
        return true
    }

    private func isToday(_ day: Int) -> Bool {
        let today = Date()
        return day == today.get(.day)
            && displayedMonth == today.get(.month)
            && displayedYear == today.get(.year)
    }

    private var canNavigateBack: Bool {
        if !includeYear { return true }
        let cal = Calendar.current
        var prevMonth = displayedMonth - 1
        var prevYear = displayedYear
        if prevMonth < 1 { prevMonth = 12; prevYear -= 1 }
        var comps = DateComponents()
        comps.year = prevYear; comps.month = prevMonth; comps.day = 1
        guard let firstOfMonth = cal.date(from: comps) else { return false }
        let daysInPrev = cal.range(of: .day, in: .month, for: firstOfMonth)?.count ?? 28
        comps.day = daysInPrev
        guard let lastOfMonth = cal.date(from: comps) else { return false }
        return lastOfMonth >= cal.startOfDay(for: validStartDate)
    }

    private var canNavigateForward: Bool {
        if !includeYear { return true }
        let cal = Calendar.current
        var nextMonth = displayedMonth + 1
        var nextYear = displayedYear
        if nextMonth > 12 { nextMonth = 1; nextYear += 1 }
        var comps = DateComponents()
        comps.year = nextYear; comps.month = nextMonth; comps.day = 1
        guard let firstOfMonth = cal.date(from: comps) else { return false }
        return cal.startOfDay(for: firstOfMonth) <= cal.startOfDay(for: validEndDate)
    }

    // MARK: - Time Helpers

    private var allowedHours: ClosedRange<Int> {
        let cal = Calendar.current
        let sameStart = cal.isDate(input, inSameDayAs: validStartDate)
        let sameEnd   = cal.isDate(input, inSameDayAs: validEndDate)
        var lower = 0, upper = 23
        if sameStart { lower = max(lower, validStartDate.get(.hour)) }
        if sameEnd   { upper = min(upper, validEndDate.get(.hour)) }
        return lower > upper ? 0...0 : lower...upper
    }

    private var allowedMinutes: ClosedRange<Int> {
        let cal = Calendar.current
        let sameStart = cal.isDate(input, inSameDayAs: validStartDate)
        let sameEnd   = cal.isDate(input, inSameDayAs: validEndDate)
        var lower = 0, upper = 59
        if sameStart && hour == validStartDate.get(.hour) {
            lower = max(lower, validStartDate.get(.minute))
        }
        if sameEnd && hour == validEndDate.get(.hour) {
            upper = min(upper, validEndDate.get(.minute))
        }
        return lower > upper ? 0...0 : lower...upper
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if !title.isEmpty {
                Text(title)
                    .smallText()
                    .padding(.leading, 7)
            }

            VStack(spacing: 0) {
                // Date string row — always visible
                dateStringRow

                // Expanded content below
                Group {
                    if editView {
                        expandedContent
                    }
                }
                .padding(.top, 15)
            }
            .padding(.horizontal)
            .padding(.vertical, 15)
            .backgroundStroke(cornerRadius: 20, colour: outlineColour)
            .backgroundFill(cornerRadius: 20, colour: backgroundColour)
            .onAppear { initializeState() }
        }
    }

    // MARK: - Date String Row (always visible)

    private var dateStringRow: some View {
        HStack(spacing: 5) {
            Spacer()

            if includeDate {
                Text(Calendar.current.monthSymbols[max(0, min(11, input.get(.month) - 1))])
                    .bodyText()
                HStack(spacing: 0) {
                    Text("\(input.get(.day))")
                        .bodyText()
                    if includeYear {
                        Text(verbatim: ",")
                            .bodyText()
                    }
                }
            }

            if includeYear {
                Text(verbatim: "\(input.get(.year))")
                    .bodyText()
            }

            if includeTime {
                if uses12HourFormat {
                    HStack(spacing: 2) {
                        Text("\(to12Hour(input.get(.hour)))")
                            .bodyText()
                        Text(":")
                            .bodyText()
                        Text(String(format: "%02d", input.get(.minute)))
                            .bodyText()
                        Text(input.get(.hour) >= 12 ? "PM" : "AM")
                            .bodyText()
                    }
                } else {
                    HStack(spacing: 0) {
                        Text(String(format: "%02d", input.get(.hour)))
                            .bodyText()
                        Text(":")
                            .bodyText()
                        Text(String(format: "%02d", input.get(.minute)))
                            .bodyText()
                    }
                }
            }

            // Circle indicator: filled = collapsed, stroked = expanded
            if editView {
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(textColour)
                    .frame(width: 8, height: 8)
                    .padding(.horizontal, 5)
            } else {
                Circle()
                    .fill(textColour)
                    .frame(width: 8, height: 8)
                    .padding(.horizontal, 5)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(duration: 0.3)) {
                editView.toggle()
            }
        }
    }

    // MARK: - Expanded Content

    private var expandedContent: some View {
        VStack() {
            if !includeDate && includeYear {
                yearGridSection
            }

            if includeDate {
                calendarSection
            }

            if includeTime {
                timeSection
            }
        }
    }

    // MARK: - Calendar Section

    private var calendarSection: some View {
        VStack(spacing: 8) {
            calendarHeader

            calendarGrid
                .id(displayedMonth + displayedYear * 100)
                .transition(.push(from: navigateForward ? .trailing : .leading))
        }
        .clipped()
        .gesture(
            DragGesture(minimumDistance: 30, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width < -50 && canNavigateForward {
                        navigateForward = true
                        withAnimation(.spring(duration: 0.3)) {
                            navigateMonth(by: 1)
                        }
                    } else if value.translation.width > 50 && canNavigateBack {
                        navigateForward = false
                        withAnimation(.spring(duration: 0.3)) {
                            navigateMonth(by: -1)
                        }
                    }
                }
        )
    }

    private var calendarHeader: some View {
        HStack {
            Button {
                navigateForward = false
                withAnimation(.spring(duration: 0.3)) {
                    navigateMonth(by: -1)
                }
            } label: {
                Symbol(symbol: "Arrow West", size: 12, colour: canNavigateBack ? textColour : Color.Control.gray1)
            }
            .disabled(!canNavigateBack)

            Spacer()

            HStack(spacing: 6) {
                // Month picker menu
                Menu {
                    Picker(selection: Binding(
                        get: { displayedMonth },
                        set: { newMonth in
                            let forward = newMonth > displayedMonth
                            navigateForward = forward
                            withAnimation(.spring(duration: 0.3)) {
                                displayedMonth = newMonth
                            }
                        }
                    ), label: EmptyView()) {
                        ForEach(allowedMonthsForDisplayedYear, id: \.self) { m in
                            Text(Calendar.current.monthSymbols[m - 1]).tag(m)
                        }
                    }
                } label: {
                    Text(Calendar.current.monthSymbols[displayedMonth - 1])
                        .bodyText()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .backgroundFill(cornerRadius: 10, colour: outlineColour)
                }

                // Year picker menu
                if includeYear {
                    Menu {
                        Picker(selection: Binding(
                            get: { displayedYear },
                            set: { newYear in
                                let forward = newYear > displayedYear
                                navigateForward = forward
                                withAnimation(.spring(duration: 0.3)) {
                                    displayedYear = newYear
                                    let allowed = allowedMonthsForDisplayedYear
                                    if displayedMonth < allowed.lowerBound {
                                        displayedMonth = allowed.lowerBound
                                    } else if displayedMonth > allowed.upperBound {
                                        displayedMonth = allowed.upperBound
                                    }
                                }
                            }
                        ), label: EmptyView()) {
                            ForEach(allowedYears, id: \.self) { y in
                                Text(verbatim: "\(y)").tag(y)
                            }
                        }
                    } label: {
                        Text(verbatim: "\(displayedYear)")
                            .bodyText()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .backgroundFill(cornerRadius: 10, colour: outlineColour)
                    }
                }
            }

            Spacer()

            Button {
                navigateForward = true
                withAnimation(.spring(duration: 0.3)) {
                    navigateMonth(by: 1)
                }
            } label: {
                Symbol(symbol: "Arrow East", size: 12, colour: canNavigateForward ? textColour : Color.Control.gray1)
            }
            .disabled(!canNavigateForward)
        }
        .padding(.horizontal, 20)
    }

    private var calendarGrid: some View {
        VStack(spacing: 6) {
            HStack(spacing: 0) {
                ForEach(0..<7, id: \.self) { i in
                    Text(weekdaySymbols[i])
                        .smallText()
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 4)

            let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
            let cells = calendarCells

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(Array(cells.enumerated()), id: \.offset) { _, day in
                    if let day = day {
                        dayCellView(day)
                    } else {
                        Color.clear.frame(height: 36)
                    }
                }
            }
        }
    }

    private func dayCellView(_ day: Int) -> some View {
        let enabled = isDayEnabled(day)
        let selected = isDaySelected(day)
        let today = isToday(day)

        return Text("\(day)")
            .bodyText()
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .background(
                Group {
                    if selected {
                        Circle().fill(textColour)
                    } else if today {
                        Circle().fill(textColour).opacity(0.25)
                    }
                }
            )
            .foregroundColor(
                selected ? backgroundColour :
                !enabled ? Color.Control.gray3 :
                .primary
            )
            .contentShape(Rectangle())
            .onTapGesture {
                guard enabled else { return }
                selectDay(day)
            }
    }

    // MARK: - Year Grid Section

    private var yearGridSection: some View {
        let years = Array(allowedYears)
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

        return ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(years, id: \.self) { yr in
                        let selected = yr == input.get(.year)
                        Text(verbatim: "\(yr)")
                            .bodyText()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selected ? textColour : Color.clear)
                            )
                            .foregroundColor(selected ? backgroundColour : .primary)
                            .id(yr)
                            .onTapGesture { selectYear(yr) }
                    }
                }
                .padding(.vertical, 4)
            }
            .frame(maxHeight: 200)
            .onAppear {
                proxy.scrollTo(input.get(.year), anchor: .center)
            }
        }
    }

    // MARK: - Time Section (one-line: End of Day pill + time pickers)

    private var timeSection: some View {
        VStack() {
            if includeDate || includeYear {
                HorizontalDivider(colour: .Control.gray1)
                    .padding(.bottom, 5)
            }

            HStack(spacing: 10) {
                // End of Day pill — highlights when time is 23:59, tap to set 23:59
                Text("End of Day")
                    .bodyText()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .foregroundColor(isEndOfDay ? backgroundColour : .primary)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isEndOfDay ? textColour : Color.clear)
                    )
                    .backgroundStroke(cornerRadius: 10, colour: isEndOfDay ? textColour : outlineColour)
                    .onTapGesture {
                        isInitializing = true
                        hour = 23
                        minute = 59
                        updateInputTime()
                        isInitializing = false
                    }

                Spacer()

                // Time pickers
                HStack(spacing: 0) {
                    if uses12HourFormat {
                        // 12H hour picker (1-12)
                        Menu {
                            Picker(selection: hour12Binding, label: EmptyView()) {
                                ForEach(1...12, id: \.self) { h in
                                    Text(verbatim: "\(h)").tag(h)
                                }
                            }
                        } label: {
                            Text("\(to12Hour(hour))")
                                .bodyText()
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .backgroundFill(cornerRadius: 10, colour: outlineColour)
                        }
                    } else {
                        // 24H hour picker (0-23)
                        Menu {
                            Picker(selection: $hour, label: EmptyView()) {
                                ForEach(allowedHours, id: \.self) {
                                    Text(verbatim: String(format: "%02d", $0))
                                }
                            }
                        } label: {
                            Text(String(format: "%02d", hour))
                                .bodyText()
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .backgroundFill(cornerRadius: 10, colour: outlineColour)
                        }
                    }

                    Text(":")
                        .bodyText()

                    // Minute picker
                    Menu {
                        Picker(selection: $minute, label: EmptyView()) {
                            ForEach(allowedMinutes, id: \.self) {
                                Text(verbatim: String(format: "%02d", $0))
                            }
                        }
                    } label: {
                        Text(String(format: "%02d", minute))
                            .bodyText()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .backgroundFill(cornerRadius: 10, colour: outlineColour)
                    }

                    // AM/PM picker (12H only)
                    if uses12HourFormat {
                        Menu {
                            Picker(selection: ampmBinding, label: EmptyView()) {
                                Text("AM").tag(false)
                                Text("PM").tag(true)
                            }
                        } label: {
                            Text(isPM ? "PM" : "AM")
                                .bodyText()
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .backgroundFill(cornerRadius: 10, colour: outlineColour)
                        }
                        .padding(.leading, 5)
                    }
                }
            }
        }
        .onChange(of: hour) {
            guard !isInitializing else { return }
            clampMinutes()
            updateInputTime()
        }
        .onChange(of: minute) {
            guard !isInitializing else { return }
            updateInputTime()
        }
    }

    // MARK: - Actions

    private func initializeState() {
        isInitializing = true
        displayedMonth = input.get(.month)
        displayedYear = input.get(.year)
        hour = input.get(.hour)
        minute = input.get(.minute)
        // Ensure seconds are always zeroed out
        if input.get(.second) != 0 {
            let cal = Calendar.current
            var comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: input)
            comps.second = 0
            if let zeroed = cal.date(from: comps) {
                input = zeroed
            }
        }
        isInitializing = false
    }

    private func navigateMonth(by offset: Int) {
        displayedMonth += offset
        if displayedMonth > 12 {
            displayedMonth = 1
            if includeYear { displayedYear += 1 }
        } else if displayedMonth < 1 {
            displayedMonth = 12
            if includeYear { displayedYear -= 1 }
        }
    }

    private func selectDay(_ day: Int) {
        let cal = Calendar.current
        var comps = DateComponents()
        comps.calendar = cal
        comps.year = includeYear ? displayedYear : input.get(.year)
        comps.month = displayedMonth
        comps.day = day
        comps.hour = includeTime ? hour : input.get(.hour)
        comps.minute = includeTime ? minute : input.get(.minute)
        comps.second = 0

        guard let newDate = cal.date(from: comps) else { return }
        input = clamp(newDate)
        autoCollapseAfterSelection()
    }

    private func selectYear(_ year: Int) {
        let cal = Calendar.current
        var comps = cal.dateComponents([.month, .day, .hour, .minute], from: input)
        comps.year = year
        comps.second = 0

        guard let newDate = cal.date(from: comps) else { return }
        input = clamp(newDate)
        autoCollapseAfterSelection()
    }

    private func updateInputTime() {
        let cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day], from: input)
        comps.hour = hour
        comps.minute = minute
        comps.second = 0

        guard let newDate = cal.date(from: comps) else { return }
        input = clamp(newDate)
    }

    private func clamp(_ date: Date) -> Date {
        if date < validStartDate { return validStartDate }
        if date > validEndDate { return validEndDate }
        return date
    }

    private func clampMinutes() {
        let range = allowedMinutes
        if minute < range.lowerBound { minute = range.lowerBound }
        if minute > range.upperBound { minute = range.upperBound }
    }

    /// Collapse immediately after selection for modes without time.
    private func autoCollapseAfterSelection() {
        if !includeTime {
            withAnimation(.spring(duration: 0.3)) {
                editView = false
            }
        }
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var date: Date = Date()
    ScrollView {
        ControlDatePicker(title: "Date + Time", input: $date)

        ControlDatePicker(title: "Date Only", input: $date, includeTime: false)
        ControlDatePicker(title: "Year Only", input: $date, includeDate: false, includeTime: false)
        ControlDatePicker(title: "Month + Day", input: $date, includeYear: false, includeTime: false)

        ControlDatePicker(title: "Bounded", input: $date, validStartDate: .now.addingTimeInterval(-100000000), validEndDate: .now.addingTimeInterval(1000))

        Text("\(date)")
    }
    .padding()
    .background(.fill)
}
