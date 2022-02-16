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
                            
                        VStack(alignment: .leading, spacing: 8) {
                            Text("This app was developed by Adam Reed of rdConcepts. It uses an MVVM design pattern and uses Combine to manage data. I also built the custom API (Django hosted on Heroku w/ Amazon S3) in order to host the songs and allow for new content to be uploaded without a new app submission, or making the user store all of the content on their phones.")
                                .font(.callout)
                            Text("Please visit my website, make an in-app purchase or download some of my other apps on the App Store.").font(.caption)
                            
        
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
                Section(header: Text("Links")) {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("My Social Media Links.")
                            Text("Check out what I am up to recently.")
                                .font(.caption)
                        }
                        
                        if colorScheme == .dark {
       
                            Link(destination: URL(string: "https://github.com/adamrd231")!, label: {
                                Image("github-light")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                            })
                            
                            Link(destination: URL(string: "https://rdconcepts.design/")!, label: {
                                Image("github-light")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                            })
                        
                            
                        } else {
                            Image("github-dark")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
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
