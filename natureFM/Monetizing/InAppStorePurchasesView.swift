import SwiftUI
import StoreKit

struct InAppStorePurchasesView: View {
    
    // Store Manager object for making in app purchases
    @StateObject var storeManager: StoreManager
    
    var body: some View {
        List {
            Section(header: Text("Subscription")) {
                if AppStore.canMakePayments {
                    ForEach(storeManager.products, id: \.id) { product in
                        Text(product.displayName)
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
