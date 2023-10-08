import SwiftUI
import StoreKit

struct ProductView: View {
    let count: Int
    let icon: String
    var body: some View {
        HStack(spacing: 3) {
            Text(count, format: .number)
            Image(systemName: icon)
        }
    }
}

struct InAppStorePurchasesView: View {
    // Store Manager object for making in app purchases
    @StateObject var storeManager: StoreManager
    
    var body: some View {
        List {
            Section(header: Text("Purchases")) {
                HStack {
                    VStack(alignment: .leading) {
                        ProductView(count: storeManager.purchasedConsumables.count, icon: "circle.fill")
                        Text("Coins")
                    }
                    
                    Spacer()
                    VStack(spacing: 3) {
                        Text("Member")
                        Image(systemName: storeManager.purchasedSubscriptions.count > 0 ? "checkmark.circle.fill" : "xmark.circle.fill")
                    }
                    Spacer()
                    VStack {
                        Text("Ads")
                        Image(systemName: storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDs.natureRemoveAdvertising}) ? "checkmark.circle.fill" : "xmark.circle.fill")
                    }
                }
            }
            Section(header: Text("Subscription")) {
                if AppStore.canMakePayments {
                    ForEach(storeManager.products, id: \.id) { product in
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
                                if storeManager.purchasedNonConsumables.contains(where: {$0.id == product.id}) || storeManager.purchasedSubscriptions.contains(where: {$0.id ==  product.id }) {
                                    Text("purchased")
                                } else {
                                    Text(product.displayPrice)
                                }
                            }
                            .disabled(storeManager.purchasedNonConsumables.contains(where: {$0.id == product.id}) || storeManager.purchasedSubscriptions.contains(where: {$0.id ==  product.id })
                            )
//                            .opacity(storeManager.purchasedNonConsumables.contains(where: {$0.id == product.id}) || storeManager.purchasedSubscriptions.contains(where: {$0.id ==  product.id }) ? 0.8 : 1.0
//                            )
                        }
                    }
                }
            }
            Section(header: Text("Restore")) {
                Text("Already purchased these? Just click below to restore all the things.")
                Button("Restore purchases") {
                    Task {
                        try await storeManager.restorePurchases()
                    }
                }
            }
        }
    }
}

struct InAppStorePurchasesView_Previews: PreviewProvider {
    static var previews: some View {
        InAppStorePurchasesView(storeManager: StoreManager())
    }
}
