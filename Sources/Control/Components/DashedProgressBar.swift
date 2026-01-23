import SwiftUI

public struct DashedProgressBar: View {
    let segments: Int
    var totalCompletion: Double
    var sectionStatus: [Bool]
    
    var progressTint: Color
    var completionTint: Color
    
    @State private var animatedCompletion: Double = 0 // State for animating completion
	
	public init(segments: Int, totalCompletion: Double, sectionStatus: [Bool], progressTint: Color, completionTint: Color) {
		self.segments = segments
		self.totalCompletion = totalCompletion
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
            withAnimation(.spring(duration: 0.7)) {
                animatedCompletion = totalCompletion
            }
        }
        .onChange(of: totalCompletion) {
            withAnimation(.spring(duration: 0.7)) {
                animatedCompletion = totalCompletion
            }
        }
    }
}

// A simple line shape to represent the progress bar
struct LineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

// Custom Shape for Dashed Clipping
struct DashedClipShape: Shape {
    let segments: Int
    let spacing: CGFloat
    let dashWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let totalSpacing = CGFloat(segments - 1) * spacing
        let totalDashWidth = CGFloat(segments) * dashWidth
        let startX = (rect.width - totalDashWidth - totalSpacing) / 2 // Center dashes horizontally
        
        for i in 0..<segments {
            let xPosition = startX + CGFloat(i) * (dashWidth + spacing)
            let dashRect = CGRect(x: xPosition, y: rect.midY - 4, width: dashWidth, height: 8)
            path.addRoundedRect(in: dashRect, cornerSize: CGSize(width: 4, height: 4))
        }
        
        return path
    }
}
