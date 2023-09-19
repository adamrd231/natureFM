import SwiftUI

struct TitleTextView: View {
    
    @State var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .font(.title2)
            .bold()
    }
}

