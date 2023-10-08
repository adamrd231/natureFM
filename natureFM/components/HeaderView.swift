import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Text("Welcome to Nature FM")
                    .font(.title)
                    .foregroundColor(Color.theme.titleColor)
                    .fontWeight(.bold)
                Spacer()
            }
            HStack {
                Text("Tune in to the great outdoors")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.titleColor)
                Spacer()
            }
           
          
        }
        .padding()
//        .frame(width: UIScreen.main.bounds.width)
//        .frame(minHeight: 130, maxHeight: 150)
        .frame(maxWidth: .infinity, minHeight: 130, maxHeight: 150)
        .background(Color.theme.backgroundColor)


    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
