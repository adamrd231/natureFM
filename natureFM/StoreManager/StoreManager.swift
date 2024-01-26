import Foundation
import StoreKit
import Combine

struct StoreIDs {
    static var NatureFM = "natureFMsubscription"
    static var natureSongDownload = "natureSongDownload"
    static var natureRemoveAdvertising = "natureRemoveAdvertising"
}

class StoreManager: ObservableObject {
    
    private var productIDs = [
        StoreIDs.NatureFM,
//        StoreIDs.natureSongDownload,
        StoreIDs.natureRemoveAdvertising
    ]
    
    @Published var products:[Product] = []
    var subscriptions: [Product] {
        products.filter({ $0.type == .autoRenewable })
    }
    @Published var purchasedNonConsumables: Set<Product> = []
    @Published var purchasedConsumables: [Product] = []
    @Published var purchasedSubscriptions: Set<Product> = []
    
    var hasSubscription: Bool {
        return purchasedSubscriptions.contains(where: { $0.id == StoreIDs.NatureFM })
    }
    
    var hasPurchasedRemoveAds: Bool {
        return purchasedNonConsumables.contains(where: { $0.id == StoreIDs.natureRemoveAdvertising })
    }
    
    var isShowingAdvertising: Bool {
        if hasSubscription || hasPurchasedRemoveAds {
            return false
        } else {
            return true
        }
    }
    
    // Listen for transactions that might be successful but not recorded
    var transactionListener: Task <Void, Error>?
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        transactionListener = listenForTransactions()
        Task {
            await requestProducts()
            // Must be called after products have already been fetched
            // Transactions do not contain product or product info
            await updateCurrentEntitlements()
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            products = try await Product.products(for: productIDs).sorted(by: { $0.price > $1.price })
        } catch let error {
            print("Error requesting products: \(error)")
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        switch result {
        case .success(.verified(let transaction)):
            switch product.id {
                case StoreIDs.NatureFM: purchasedSubscriptions.insert(product)
                case StoreIDs.natureSongDownload: purchasedConsumables.append(product)
                case StoreIDs.natureRemoveAdvertising: purchasedNonConsumables.insert(product)
                default: print("Error adding purchased product to history")
            }
            
            await transaction.finish()
            return transaction
            
        default: return nil
        }
    }
    
    func listenForTransactions() -> Task <Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                await self.handle(transactionVerification: result)
            }
        }
    }
    
    private func updateCurrentEntitlements() async {
        for await result in Transaction.currentEntitlements {
            await self.handle(transactionVerification: result)
        }
    }
    
    @MainActor
    func restorePurchases() async throws {
        try await AppStore.sync()

    }

    @MainActor
    private func handle(transactionVerification result: VerificationResult <Transaction> ) async {
        switch result {
            case let.verified(transaction):
                guard let product = self.products.first(where: { $0.id == transaction.productID }) else { return }
                switch product.id {
                    case StoreIDs.NatureFM: purchasedSubscriptions.insert(product)
                    case StoreIDs.natureSongDownload: purchasedConsumables.append(product)
                    case StoreIDs.natureRemoveAdvertising: purchasedNonConsumables.insert(product)
                    default: print("Error adding purchased product to history")
                }
                await transaction.finish()
            default: return
        }
    }
}
