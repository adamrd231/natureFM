//
//  StoreManager.swift
//  adamsCalc
//
//  Created by Adam Reed on 6/29/21.
//

import Foundation
import StoreKit
import CoreData

class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published var myProducts = [SKProduct]()
    var request: SKProductsRequest!
    @Published var transactionState: SKPaymentTransactionState?
//    @Published var purchasedRemoveAds = true
    @Published var purchasedRemoveAds = UserDefaults.standard.bool(forKey: "purchasedRemoveAds") {
        didSet {
            UserDefaults.standard.setValue(self.purchasedRemoveAds, forKey: "purchasedRemoveAds")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            print("product array isnt empy")
            for fetchedProduct in response.products {
                print("fetching products is working")
                DispatchQueue.main.async {
                    print("Adding to products \(fetchedProduct.localizedTitle)")
                    self.myProducts.append(fetchedProduct)
                }
            }
        }
        
        
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }

    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                purchasedRemoveAds = true
                transactionState = .purchased
            case .restored:
                UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                purchasedRemoveAds = true
                transactionState = .restored
            case .failed, .deferred:
                print("Payment Queue Error: \(String(describing: transaction.error))")
                    queue.finishTransaction(transaction)
                    transactionState = .failed
                    default:
                    queue.finishTransaction(transaction)
            }
        }
    }
    
    func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payment.")
        }
    }
    
    
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
}
