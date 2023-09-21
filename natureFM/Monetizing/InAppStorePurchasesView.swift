import SwiftUI

struct InAppStorePurchasesView: View {
    
    // Store Manager object for making in app purchases
    @StateObject var storeManager: StoreManager
    
    var body: some View {
        Text("Hello")
    }
}

struct InAppStorePurchasesView_Previews: PreviewProvider {
    static var previews: some View {
        InAppStorePurchasesView(storeManager: StoreManager())
    }
}
