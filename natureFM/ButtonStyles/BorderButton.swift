import SwiftUI

struct BorderButton: ButtonStyle {
    let color: Color
    let isSelected: Bool
    
    init(color: Color, isSelected: Bool = false) {
        self.color = color
        self.isSelected = isSelected
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(color)
            .font(.callout)
            .fontWeight(isSelected ? .heavy : .regular)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .overlay(
                Capsule()
                    .strokeBorder(color, lineWidth: isSelected ? 3 : 1)
            )
    }
}
