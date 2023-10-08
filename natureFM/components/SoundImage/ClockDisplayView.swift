import SwiftUI

struct ClockDisplayView: View {
    let time: Int
    let font: Font

    var body: some View {
        HStack(spacing: 3) {
            if time / 60 > 0 {
                HStack(spacing: 0) {
                    Text(time / 60, format: .number)
                    Text("m")
                }
            }
            HStack(spacing: 0) {
                Text(time % 60, format: .number)
                Text("s")
            }
        }
        .font(font)
    }
}

struct ClockDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ClockDisplayView(time: 603, font: .caption)
    }
}
