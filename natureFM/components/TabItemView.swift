import SwiftUI

struct TabItemView: View {
    let text: String
    let image: String
    var body: some View {
        VStack {
            Text(text)
            Image(systemName: image)
        }
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(text: "Hello", image: "creditcard")
    }
}
