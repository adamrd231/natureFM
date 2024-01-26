import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var vm: CatalogViewModel
    // Store manager variable for in-app purchases
    @StateObject var storeManager: StoreManager
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://apps.apple.com/in/app/naturefm/id1576891060") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            Section(header: Text("Share")) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Share this app.")
                        Text("Help support my app and share NatureFM to friends/family. Let's tune in to the outdoors together!")
                            .font(.caption)
                    }
                    
                    Spacer()
                    Button(action: actionSheet) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.theme.titleColor)
                    }
                    
                }
                .padding(5)
            }
            
            Section(header: Text("About")) {
                HStack(alignment: .top, spacing: 15) {
                    Image("adam")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 85, height: 85)
                        .cornerRadius(10)
                        .clipped()
                    VStack(alignment: .leading, spacing: 5) {
                        Text("iOS Engineer Adam Reed.")
                            .fontWeight(.bold)
                        Text("Please visit my website, leave a review, make an in-app purchase or download some of my other apps on the App Store.")
                    }
                }
                .font(.caption)
                .padding(5)
            }
            
            Section(header: Text("Github")) {
                VStack(alignment: .leading) {
                    Link(destination: URL(string: "https://github.com/adamrd231")!, label: {
                        Image(colorScheme == .dark ? "github-light" : "github-dark")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                    })
                    Text("Dev Projects")
                    Text("Swift, iOS, Xcode, Python, React, HTML, CSS, Javascript.")
                        .font(.caption)
                }
                .padding(5)
            }
            
            Section(header: Text("Website")) {
                VStack(alignment: .leading) {
                    Link(destination: URL(string: "https://rdconcepts.design/")!, label: {
                        Image(colorScheme == .dark ? "web-light" : "web-dark")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                    })
                    Text("Portfolio Website")
                    Text("My recent projects and blogs, built with React.js, backend hosted on Heroku and built with Python and Django.")
                        .font(.caption)
                }
                .padding(5)
            }
            
            Section(header: Text("rdConcepts on App Store")) {
                VStack(alignment: .leading) {
                    Link(destination: URL(string: "https://apps.apple.com/us/developer/rd-concepts/id1293498470")!, label: {
                        Image(colorScheme == .dark ? "app-store-light" : "app-store-dark")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                    })
                    Text("All Apps I've Developed.")
                    Text("I have launched twelve applications to the App Store, calculators, workout timers, crypto trading games and more.")
                        .font(.caption)
                }
                .padding(5)
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(storeManager: StoreManager())
    }
}
