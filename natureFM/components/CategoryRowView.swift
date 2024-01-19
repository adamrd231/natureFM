//
//  CategoryRowView.swift
//  natureFM
//
//  Created by Adam Reed on 1/18/24.
//

import SwiftUI

struct CategoryRowView: View {
    let categories: [CategoryName]
    @Binding var selectedCategory: Int
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            Text("Categories")
            HStack {
                HStack(alignment: .center) {
                    OverflowLayout(spacing: 10) {
                        ForEach(Array(zip(categories.indices, categories)), id: \.0) { index, category in
                            Button(categories[index].title) {
                                selectedCategory = index
                            }
                            .buttonStyle(BorderButton(color: Color.theme.titleColor, isSelected: category.title == categories[selectedCategory].title))
//                            Button {
//                                selectedCategory = index
//                            } label: {
//                                ZStack {
//                                    if selectedCategory == index {
//                                        Capsule()
//                                            .foregroundColor(.blue)
//                                        Text(categories[index].title)
//                                            .foregroundColor(.white)
//                                            .fontWeight(.bold)
//                                            .padding(10)
//                                            .padding(.horizontal, 10)
//
//                                    } else {
//                                        Text(categories[index].title)
//
//                                            .padding(10)
//                                            .padding(.horizontal, 10)
//                                            .foregroundColor(.black)
//                                        Capsule()
//                                            .strokeBorder(Color.black, lineWidth: 0.8)
//                                    }
//                                }
//                                .padding(.horizontal, 1)
//                                .font(.caption)
//                            }
                        }
                    }
                }
                Spacer()
            }
            
        }
        .padding()
    }
}

struct CategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRowView(categories: [
            CategoryName(title: "all"),
            CategoryName(title: "Basic b"),
            CategoryName(title: "Basic b")
//            CategoryName(title: "Basic b"),
//            CategoryName(title: "Basic b"),
//            CategoryName(title: "Basic b")
        ], selectedCategory: .constant(0))
    }
}

struct OverflowLayout: Layout {
    var spacing = CGFloat(10)
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let containerWidth = proposal.replacingUnspecifiedDimensions().width
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, containerWidth: containerWidth).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, containerWidth: bounds.width).offsets
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: CGPoint(x: offset.x + bounds.minX, y: offset.y + bounds.minY), proposal: .unspecified)
        }
    }
    
    func layout(sizes: [CGSize], containerWidth: CGFloat) -> (offsets: [CGPoint], size: CGSize) {
        var result: [CGPoint] = []
        var currentPosition: CGPoint = .zero
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0
        for size in sizes {
            if currentPosition.x + size.width > containerWidth {
                currentPosition.x = 0
                currentPosition.y += lineHeight + spacing
                lineHeight = 0
            }
            
            result.append(currentPosition)
            currentPosition.x += size.width
            maxX = max(maxX, currentPosition.x)
            currentPosition.x += spacing
            lineHeight = max(lineHeight, size.height)
        }
        
        return (result, CGSize(width: maxX, height: currentPosition.y + lineHeight))
    }
}



