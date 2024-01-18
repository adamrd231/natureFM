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
    @EnvironmentObject var vm: CatalogViewModel
    @Binding var currentTab: Int
    
    var body: some View {
        List {
            Section(header: Text("About me")) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Whyyyy?")
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
            
            Section(header: Text("Purchases")) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 3) {
                        Image(systemName: storeManager.hasSubscription ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(storeManager.hasSubscription ? Color.theme.customBlue : Color.theme.customRed)
                        Text("Member")
                    }
                    HStack(spacing: 3) {
                        Image(systemName: !storeManager.isShowingAdvertising ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(!storeManager.isShowingAdvertising ? Color.theme.customBlue : Color.theme.customRed.opacity(0.66))
                        Text("Ads")
                        Text("--")
                            .font(.caption2)
                        Text(storeManager.isShowingAdvertising ? "Showing adverts" : "free from adverts")
                            .font(.caption2)
                    }
                }
                .font(.callout)
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
        InAppStorePurchasesView(
            storeManager: StoreManager(),
            currentTab: .constant(1)
        )
    }
}
