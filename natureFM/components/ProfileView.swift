//
//  ProfileView.swift
//  natureFM
//
//  Created by Adam Reed on 2/16/22.
//

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
        VStack(spacing: 5) {
            Text("Profile")
                .font(.title)
                .fontWeight(.bold)
            Text("Downloaded on Jan 1 2021")
                .font(.caption)
            Text(storeManager.purchasedRemoveAds ? "Member" : "Free User")
                .font(.caption)
                .fontWeight(.bold)
            
            HStack(spacing: 15) {
                VStack {
                    Text("Total Sounds")
                    Text("\(vm.allSounds.count)")
                    
                }
                VStack {
                    Text("Sounds Downloaded")
                    Text("\(vm.portfolioSounds.count)")
                }

            }
            .padding(.bottom)
            .font(.caption)
            
            Form {
                Section(header: Text("About")) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Image("adam")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .clipped()
                            
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Thanks for using my app.")
                                .fontWeight(.medium)
                            
                            Text("This app was developed by Adam Reed of rdConcepts. It uses an MVVM design pattern and uses Combine, CoreData, and FileManager to manage data. Frontend design for this app is developed with SwiftUI.")
                                .font(.callout)
                            Text("The backend API was built using Python 3, the Django web framework, hosted on Heroku, and supported by Amazon S3 Storages to manage image and audio file hosting. This project made sense to have it's own API to store and serve content, so user's can download only the things they want onto their device. This also sets up the possibilty of an android or web-app versions that can interact with the same data set.")
                                .font(.callout)
                            Text("Please visit my website, make an in-app purchase or download some of my other apps on the App Store.")
                                .font(.callout)
                            
        
                        }
                    }
                    .padding()
                }
                
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
                Section(header: Text("Github")) {
                    VStack(alignment: .leading) {
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
                        
                        VStack(alignment: .leading) {
                            Text("Dev Projects")
                            Text("Swift, iOS, Xcode, Python, React, HTML, CSS, Javascript.")
                                
                                .font(.caption)
                        }

                    }
                    .padding()
                }
                
                Section(header: Text("Website")) {
                    VStack(alignment: .leading) {
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
                        VStack(alignment: .leading) {
                            Text("Portfolio Website")
                            Text("My recent projects and blogs, built with React.js, backend hosted on Heroku and built with Python and Django.")
                                
                                .font(.caption)
                                
                        }
                    }
                    .padding()
                }
                
                Section(header: Text("rdConcepts on App Store")) {
                    VStack(alignment: .leading) {
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
                        VStack(alignment: .leading) {
                            Text("All Apps I've Developed.")
                            Text("I have launched eight applications to the App Store, calculators, workout timers, crypto trading games and more.")
                                .font(.caption)
                                
                        }
                    }
                    .padding()
                }
            }
            
            
            
        }.padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(storeManager: StoreManager())
    }
}
