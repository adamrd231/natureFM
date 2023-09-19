import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome to Nature FM")
                .font(.title)
                .foregroundColor(Color.theme.titleColor)
            Text("Tune in to the great outdoors")
                .font(.subheadline)
                .foregroundColor(Color.theme.titleColor)
                .bold()
                .padding(.bottom)
        }.padding(.top)
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
