import SwiftUI

struct HeaderView: View {
    
    let natureCoins: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack(spacing: 3) {
                Text("Welcome to Nature FM")
                    .font(.title)
                    .foregroundColor(Color.theme.titleColor)
                    .fontWeight(.bold)
            }
            HStack {
                Text("Tune in to the great outdoors")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.titleColor)
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 130, maxHeight: 150)
        .background(Color.theme.backgroundColor)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(natureCoins: 3)
    }
}
