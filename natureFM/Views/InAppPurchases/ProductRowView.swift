import SwiftUI
import StoreKit

struct ProductRowView: View {
    let product: Product
    let hasPurchased: Bool
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .bold()
                Text(product.description)
                    .font(.footnote)
            }
            Spacer()
            Button {
                // Buy product
                Task {
                    try await storeManager.purchase(product)
                }
            } label: {
                HStack {
                    if hasPurchased {
                        Image(systemName: "checkmark")
                    }
                    Text(hasPurchased ? "purchased" : product.displayPrice)
                        .foregroundColor(Color.theme.customBlue)
                }
            }
            .disabled(hasPurchased)
        }
    }
}

//struct ProductRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductRowView(
//            product: ,
//            hasPurchased: true,
//            storeManager: StoreManager()
//        )
//    }
//}
