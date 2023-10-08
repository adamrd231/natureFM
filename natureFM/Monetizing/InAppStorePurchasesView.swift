import SwiftUI
import StoreKit

struct InAppStorePurchasesView: View {
    
    // Store Manager object for making in app purchases
    @StateObject var storeManager: StoreManager
    
    var body: some View {
        List {
            Section(header: Text("Purchases")) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 3) {
                            Text("0")
                            Image(systemName: "leaf.circle.fill")
                        }
                        Text("Coins")
                    }
                    
                    Spacer()
                    VStack(spacing: 3) {
                        Text("Member")
                        Image(systemName: "checkmark.circle.fill")
                    }
                    Spacer()
                    VStack {
                        Text("Ads")
                        Image(systemName: "xmark.circle.fill")
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
                                Text(product.displayPrice)
                            }
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
