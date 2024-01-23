import SwiftUI
import GoogleMobileAds

private struct BannerVC: UIViewControllerRepresentable  {
    
    private struct BannerAdMobConstant {
        #if DEBUG
            static var bannerID = "ca-app-pub-3940256099942544/2934735716"
        #else
            static var bannerID = "ca-app-pub-4186253562269967/6799659487"
        #endif
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let size = CGSize(width: UIScreen.main.bounds.width, height: 50)
        
        let view = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        let viewController = UIViewController()
        view.adUnitID = BannerAdMobConstant.bannerID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
 
        viewController.view.frame = CGRect(origin: .zero, size: size)
        view.load(GADRequest())
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct AdmobBanner:View{
    var body: some View{
        BannerVC()
            .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

struct AdmobBanner_Previews: PreviewProvider {
    static var previews: some View {
        AdmobBanner()
    }
}
