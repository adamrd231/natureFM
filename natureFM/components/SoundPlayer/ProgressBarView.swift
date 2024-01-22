import SwiftUI

struct ProgressBarView: View {
    @State var wasPlaying: Bool = false
    @State var isDragging: Bool = false
    // Is player playing?
    @State var isPlaying: Bool = true
    // stop player
    @State var stopPlayer: () -> Void
    // start player
    @State var startPlayer: () -> Void
//    // current time -- BINDING
//    @Binding var currentTime: Int
//    // duration
//    @State var duration: Int
//
//    // percentage played -- COMPUTED from current time and duration
//    var percentagePlayed: Double {
//        return Double(currentTime) / Double(duration)
//    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { isChanging in
                // Stops player when user clicks and starts dragging
                stopPlayer()
            }
            .onEnded { isDragging in
                // Update current time
                // start player
                let percentageToGoTo = isDragging.location.x / UIScreen.main.bounds.width * 0.9
//                currentTime = Int(percentageToGoTo * CGFloat(duration))
                startPlayer()

            }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.theme.backgroundColor)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                Rectangle()
                    .foregroundColor(Color.theme.customBlue)
//                    .frame(width: ((UIScreen.main.bounds.width * 0.9) * percentagePlayed))
                   
            }
            .frame(height: 5)
            .cornerRadius(5)
            .padding(.horizontal)
            .overlay(alignment: .leading) {
                Circle()
                    .foregroundColor(Color.theme.customBlue)
                    .frame(width: 15, height: 15)
//                    .offset(x: (UIScreen.main.bounds.width * 0.9) * percentagePlayed + 10)
                    .gesture(drag)
            }
            
//            HStack {
//                ClockDisplayView(time: Int(currentTime), font: .caption)
//                Spacer()
//                ClockDisplayView(time: Int((duration) - 1), font: .caption)
//            }
//            .padding(.horizontal)
//            .font(.caption)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(
            stopPlayer: {},
            startPlayer: {}
//            currentTime: .constant(45),
//            duration: 60
        )
    }
}
