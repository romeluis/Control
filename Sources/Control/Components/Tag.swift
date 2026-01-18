//
//  Tag.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2024-12-21.
//

import SwiftUI

struct Tag: View {
    //Inputs
    var text: String
    var colour: Color
    var size: TagSize = .medium
    var bold: Bool = false
    var wrap: Bool = false
    var type: TagType = .square
    
    //Calculated sizes
    private var verticalPadding: CGFloat {
        switch size {
        case .small:
            return 3
        case .medium:
            return 3
        }
    }
    private var horizontalPadding: CGFloat {
        switch size {
        case .small:
            return 6
        case .medium:
            return 7
        }
    }
    private var fontSize: CGFloat {
        switch size {
        case .small:
            return 15
        case .medium:
            return 20
        }
    }
    private var cornerRadius: CGFloat {
        switch size {
        case .small:
            return 6
        case .medium:
            return 9
        }
    }
    
    public init(text: String, colour: Color, size: TagSize = .medium, bold: Bool = false, wrap: Bool = false, type: TagType = .square) {
		self.text = text
		self.colour = colour
		self.size = size
		self.bold = bold
		self.wrap = wrap
		self.type = type
	}
    
    public var body: some View {
        switch type {
        case .square:
            Text(text)
                .bold(bold)
                .if(size == .medium) { content in
                    content
                        .bodyText()
                }
                .if(size == .small) { content in
                    content
                        .smallText()
                }
                .if(!wrap) { content in
                    content
                        .lineLimit(1)
                        .fixedSize()
                }
				.foregroundColor(.Control.white)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(RoundedRectangle(cornerRadius: cornerRadius).fill(colour))
        case .round:
            Text(text)
                .bold(bold)
                .if(size == .medium) { content in
                    content
                        .bodyText()
                }
                .if(size == .small) { content in
                    content
                        .smallText()
                }
                .if(!wrap) { content in
                    content
                        .lineLimit(1)
                        .fixedSize()
                }
				.foregroundColor(.Control.white)
                .padding(.horizontal, horizontalPadding + 5)
                .padding(.vertical, verticalPadding)
                .background(RoundedRectangle(cornerRadius: 50).fill(colour))
        }
    }
}
