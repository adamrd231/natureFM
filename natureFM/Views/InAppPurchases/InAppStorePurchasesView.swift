import SwiftUI
import StoreKit

struct InAppStorePurchasesView: View {
    // Store Manager object for making in app purchases
    @StateObject var storeManager: StoreManager
    @EnvironmentObject var vm: CatalogViewModel
    @Binding var currentTab: Int
    
    var body: some View {
        NavigationStack {
            List {
                if AppStore.canMakePayments {
                    Section(header: Text("Subscriptions")) {
                        ForEach(storeManager.subscriptions, id: \.id) { product in
                            ProductRowView(
                                product: product,
                                hasPurchased: storeManager.hasSubscription,
                                storeManager: storeManager
                            )
                        }
                    }
                    
                    Section(header: Text("In-App Purchases")) {
                        ForEach(storeManager.nonConsumableProducts, id: \.id) { product in
                            ProductRowView(
                                product: product,
                                hasPurchased: storeManager.purchasedNonConsumables.contains(product),
                                storeManager: storeManager
                            )
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
                    
                    Section(header: Text("About me")) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Why In-App Purchases?")
                                .font(.callout)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.theme.titleColor)
                            VStack(alignment: .leading) {
                                Text(
                                    """
                                    I am a software engineer working towards supporting myself with revenue from the apps I develop. I use google admob to advertise on
                                    my platforms, and by advertising and offering in-app purchases, I can afford to spend more time on new features and apps. Purchasing the monthly subscription will remove the advertising as well as unlock premium content.
                                    """
                                )
                                Text("Thank you for supporting my on my journey!")
                            }
                            .font(.caption)
                            Button("Learn more") {
                                currentTab = 4
                            }
                        }
                    }
                } else {
                    Text("This account is not verified to make payments.")
                }
            }
            .navigationTitle("In App Purchases")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Link(destination: URL(string: "https://rdconcepts.design/#/privacy")!) {
                        Text("Privacy Policy")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!) {
                        Text("Terms & Conditions")
                    }
                }
            }
        }
        
    }
}

struct InAppStorePurchasesView_Previews: PreviewProvider {
    static var previews: some View {
        InAppStorePurchasesView(
            storeManager: StoreManager(),
            currentTab: .constant(1)
        )
    }
}
