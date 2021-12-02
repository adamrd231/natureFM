//
//  GoogleBannerAd.swift
//  natureFM
//
//  Created by Adam Reed on 10/3/21.
//

import SwiftUI
import GoogleMobileAds
import UIKit

final private class BannerVC: UIViewControllerRepresentable  {
    
    
    var testBannerAdId = "ca-app-pub-3940256099942544/2934735716"
    var realBannerAdId = "ca-app-pub-4186253562269967/6799659487"

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        // Setup the real or test banner id
        view.adUnitID = realBannerAdId
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct Banner:View{
    var body: some View{
        HStack(alignment: .center) {
            BannerVC()
                .background(Color(.systemGray6))
                .frame(width: 320, height: 60, alignment: .center)
        }
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner()
    }
}
