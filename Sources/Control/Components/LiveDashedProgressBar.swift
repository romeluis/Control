import SwiftUI

public struct LiveDashedProgressBar: View {
    let segments: Int
    @Binding var totalCompletion: Double
    var sectionStatus: [Bool]
    
    var progressTint: Color
    var completionTint: Color
    
    @State private var animatedCompletion: Double = 0 // State for animating completion
	
	public init(segments: Int, totalCompletion: Binding<Double>, sectionStatus: [Bool], progressTint: Color, completionTint: Color) {
		self.segments = segments
		self._totalCompletion = totalCompletion
		self.sectionStatus = sectionStatus
		self.progressTint = progressTint
		self.completionTint = completionTint
	}
    
    public var body: some View {
        GeometryReader { geometry in
            let dashWidth = (geometry.size.width - CGFloat(segments - 1) * 8) / CGFloat(segments)
            let spacing = 8.0
            let totalSpacing = CGFloat(segments - 1) * spacing
            let startX = (geometry.size.width - CGFloat(segments) * dashWidth - totalSpacing) / 2
            
            ZStack {
                // Background dashes
                HStack(spacing: spacing) {
                    ForEach(0..<segments, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: dashWidth, height: 8)
                            .foregroundColor(completionTint)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Foreground progress line clipped by dashes
                LineShape()
                    .trim(from: 0, to: animatedCompletion) // Animate this trim
                    .stroke(progressTint, lineWidth: 8)
                    .clipShape(DashedClipShape(segments: segments, spacing: spacing, dashWidth: dashWidth)) // Apply dashes as clip
                
                // Alert symbols
                ForEach(0..<segments, id: \.self) { index in
                    if sectionStatus.indices.contains(index), sectionStatus[index] {
                        Image("Alert Symbol Pink")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .position(x: startX + CGFloat(index) * (dashWidth + spacing) + dashWidth / 2,
                                      y: geometry.size.height / 2)
                    }
                }
            }
        }
        .frame(height: 20) // Fixed height for the progress bar
        .onAppear {
            withAnimation(.easeOut(duration: 1)) {
                animatedCompletion = totalCompletion
            }
        }
    }
}
