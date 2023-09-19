import SwiftUI

struct LoadingFromAPIView: View {
    var body: some View {
        VStack {
            Text("Loading Nature FM Sounds")
                .bold()
                .font(.subheadline)
                .padding(.top)
            Text("This usually takes between 5 - 30 seconds.")
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.bottom)
            Text("If it is taking a load time to load, try checking your internet/cellular connection or just re-starting the app.")
                .font(.subheadline)
                .padding(.horizontal)
            Spacer()
        }
    }
}

struct LoadingFromAPIView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingFromAPIView()
    }
}
