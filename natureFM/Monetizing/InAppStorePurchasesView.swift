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
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        List {
            Section(header: Text("Purchases")) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 3) {
                        Image(systemName: storeManager.hasSubscription ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(storeManager.hasSubscription ? Color.theme.customBlue : Color.theme.customRed)
                            
                        Text("Member")
              
                      
                    }
                    HStack(spacing: 3) {
                        Image(systemName: storeManager.hasPurchasedRemoveAds ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(storeManager.hasPurchasedRemoveAds ? Color.theme.customBlue : Color.theme.customRed.opacity(0.66))
                        Text("Ads")
                  
                    }
                }
                .font(.callout)
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
                                        .foregroundColor(Color.theme.customBlue)
                                } else {
                                    Text(product.displayPrice)
                                        .foregroundColor(Color.theme.customBlue)
                                }
                            }
                            .disabled(storeManager.purchasedNonConsumables.contains(where: {$0.id == product.id}) || storeManager.purchasedSubscriptions.contains(where: {$0.id ==  product.id })
                            )
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
                .foregroundColor(Color.theme.customBlue)
            }
        }
    }
}

struct InAppStorePurchasesView_Previews: PreviewProvider {
    static var previews: some View {
        InAppStorePurchasesView(storeManager: StoreManager())
    }
}
