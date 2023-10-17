import SwiftUI
import GoogleMobileAds

class AdvertisingViewModel: ObservableObject {
    static let shared = AdvertisingViewModel()
    @Published var interstitialCount:Int = 0 {
        didSet {
            if interstitialCount > 3 {
                showInterstitial = true
                interstitialCount = 0
            }
        }
    }
    @Published var interstitial = InterstitialAdManager.Interstitial()
    @Published var showInterstitial = false {
        didSet {
            if showInterstitial {
                interstitial.showAd()
                showInterstitial = false
            } else {
                interstitial.requestInterstitialAds()
            }
        }

    }
}
