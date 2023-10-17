import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var vm: HomeViewModel
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
                        Text("Send NatureFM to friends/family.")
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
                    
                }.padding()
            }
            
            Section(header: Text("About")) {
                VStack(spacing: 10) {
                    Image("adam")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                        .clipped()
                    
                    VStack(spacing: 10) {
                        Text("Thanks for using my app.")
                            .fontWeight(.medium)
                            .font(.caption)
                        Text("Please visit my website, leave a review, make an in-app purchase or download some of my other apps on the App Store.")
                           
                    }
                }
                .padding()
            }
            
            Section(header: Text("Github")) {
                VStack {
                    if colorScheme == .dark {
                        Link(destination: URL(string: "https://github.com/adamrd231")!, label: {
                            Image("github-light")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                        })
                        
                    } else {
                        Link(destination: URL(string: "https://github.com/adamrd231")!, label: {
                            Image("github-dark")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                        })
                    }
                    
                    VStack {
                        Text("Dev Projects")
                        Text("Swift, iOS, Xcode, Python, React, HTML, CSS, Javascript.")
                        
                            .font(.caption)
                    }
                    
                }
                .padding()
            }
            
            Section(header: Text("Website")) {
                VStack {
                    if colorScheme == .dark {
                        Link(destination: URL(string: "https://rdconcepts.design/")!, label: {
                            Image("web-light")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                        })
                    } else {
                        Link(destination: URL(string: "https://rdconcepts.design/")!, label: {
                            Image("web-dark")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                        })
                    }
                    VStack {
                        Text("Portfolio Website")
                        Text("My recent projects and blogs, built with React.js, backend hosted on Heroku and built with Python and Django.")
                        
                            .font(.caption)
                        
                    }
                }
                .padding()
            }
            
            Section(header: Text("rdConcepts on App Store")) {
                VStack {
                    if colorScheme == .dark {
                        Link(destination: URL(string: "https://apps.apple.com/us/developer/rd-concepts/id1293498470")!, label: {
                            Image("app-store-light")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                        })
                    } else {
                        Link(destination: URL(string: "https://apps.apple.com/us/developer/rd-concepts/id1293498470")!, label: {
                            Image("app-store-dark")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                        })
                    }
                    VStack {
                        Text("All Apps I've Developed.")
                        Text("I have launched eight applications to the App Store, calculators, workout timers, crypto trading games and more.")
                            .font(.caption)
                        
                    }
                }
                .padding()
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(storeManager: StoreManager())
    }
}
