// This was modified from a Medium article
// https://medium.com/@priyankasaroha/swiftui-skeletons-e7944085567e
// Credit: Priyanka Saroha

import SwiftUI

struct BlinkViewModifier: ViewModifier {
    let duration: Double
    @State private var blinking: Bool = false
    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0.3 : 1)
            .animation(.easeInOut(duration: duration).repeatForever(), value: blinking)
            .onAppear {
                blinking.toggle()
            }
    }
}

extension View {
    func blinking(duration: Double = 1) -> some View {
        modifier(BlinkViewModifier(duration: duration))
    }
}
