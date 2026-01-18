//
//  DynamicScroll.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2024-12-25.
//

import SwiftUI

struct dynamicScroll: ViewModifier {
    var scrollFunction: (_ value: Double) -> Void
    @Binding var scrollDisabled: Bool
    @State private var internalScrollDisabled: Bool = true
    @State private var isScrollGestureActive: Bool = false
    @State private var disableTask: Task<Void, Never>?
    
    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: Double.self) { geo in
                geo.contentOffset.y
            } action: { oldValue, newValue in
                // Track when scroll gesture is happening
                if oldValue != newValue {
                    isScrollGestureActive = true
                    disableTask?.cancel()
                    
                    // Reset gesture tracking after a short delay
                    disableTask = Task {
                        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
                        if !Task.isCancelled {
                            await MainActor.run {
                                isScrollGestureActive = false
                                updateScrollState()
                            }
                        }
                    }
                }
                
                withAnimation {
                    scrollFunction(newValue)
                }
            }
            .scrollDisabled(!internalScrollDisabled)
            .onChange(of: scrollDisabled) { _, newValue in
                updateScrollState()
            }
            .onAppear {
                internalScrollDisabled = scrollDisabled
            }
    }
    
    private func updateScrollState() {
        if scrollDisabled {
            // Enable scroll immediately when drawer opens
            internalScrollDisabled = true
        } else {
            // Only disable scroll if no gesture is currently active
            if !isScrollGestureActive {
                internalScrollDisabled = false
            } else {
                // If gesture is active, delay the disable
                disableTask?.cancel()
                disableTask = Task {
                    try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 second delay
                    if !Task.isCancelled {
                        await MainActor.run {
                            internalScrollDisabled = false
                        }
                    }
                }
            }
        }
    }
}
extension View {
    public func DynamicScroll(scrollState: Binding<Bool>, scrollFunction: @escaping (Double) -> Void) -> some View {
        modifier(dynamicScroll(scrollFunction: scrollFunction, scrollDisabled: scrollState))
    }
}
