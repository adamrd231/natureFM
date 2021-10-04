//
//  SoundsTableView.swift
//  natureFM
//
//  Created by Adam Reed on 8/12/21.
//

import SwiftUI
import URLImage

struct SoundsTableView: View {
    
    @EnvironmentObject var soundsModel: SoundsModel
    @State var soundsModelArray:[SoundsModel] = []
    @State var viewingSoundPlayer = false
    
    // Variable to track the current search parameter
    @State var currentCategory = CategoryModel()
    @State var categoryModelArray:[CategoryModel] = []
    
    @State private var isLoading = false
    
    // Variable to track the current search parameter
    @State private var currentSearchText: String = ""

    
    func loadCategories() {
        guard let url = URL(string: "https://nature-fm.herokuapp.com/app/category/") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode([CategoryModel].self, from: data) {
                    DispatchQueue.main.async {
                        self.categoryModelArray = response
                    }
                    return
                }
            }
        }.resume()
    }
    
    // load data from database into the program
    func loadData() {
        isLoading = true
        guard let url = URL(string: "https://nature-fm.herokuapp.com/app/sound/") else {
            print("Invalid URL")
            return
        }
        print(url)
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode([SoundsModel].self, from: data) {
                    DispatchQueue.main.async {
                        self.soundsModelArray = response
                        isLoading = false
                    }
                    return
                }
            }
        }.resume()
        
    }
    
    
    var body: some View {
        
        NavigationView() {
            TabView {
                // First Page
                VStack {
                    // Search Bar
                    TextField("Search", text: $currentSearchText).padding(.leading).padding(.trailing)
                    
                    
                    // Segmented Controller
                    Picker("Category", selection: $currentCategory.title) {
                        ForEach(categoryModelArray) { category in
                            Text("\(category.title)")
                        }
                    }.pickerStyle(SegmentedPickerStyle())

                    HStack {
                        Button(action: {
                            loadData()
                        }) {
                            Text("Reset")
                        }
                        Spacer()
                        Button(action: {
                            loadData()
                        }) {
                            Text("Update Search")
                        }
                    }.padding(.leading).padding(.trailing)
                    
                    // Table of sounds
                    List {
                        ForEach(soundsModelArray) { sound in
                            ZStack {
                                
                                URLImage(URL(string: "\(sound.imageFileLink ?? "")")!) { progress in
                                    // Display progress
                                    Image("placeholder").resizable().aspectRatio(contentMode: .fill)
                                } failure: { error, retry in
                                    // Display error and retry button
                                    VStack {
                                        Text(error.localizedDescription)
                                        Button("Retry", action: retry)
                                    }
                                } content: { image in
                                    // Downloaded image
                                    ZStack {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        Color(.black).opacity(0.5)
                                    }
                                    
                                }
                                
                                HStack {
                                    Spacer()
                                    VStack(alignment: .center) {
                                        Text("\(sound.name)").font(.title).bold().foregroundColor(.white)
                                        Text("Location").font(.subheadline).bold().foregroundColor(.white)
                                        Text("\(sound.locationName)").font(.caption).foregroundColor(.white)
                                        Text("Category").font(.subheadline).bold().foregroundColor(.white)
                                        Text("\(sound.categoryName)").font(.caption).foregroundColor(.white)
                                        
                                        Button(action: {
                                            soundsModel.name = sound.name
                                            soundsModel.duration = sound.duration
                                            soundsModel.categoryName = sound.categoryName
                                            soundsModel.locationName = sound.locationName
                                            soundsModel.imageFileLink = sound.imageFileLink
                                            soundsModel.audioFileLink = sound.audioFileLink
                                            soundsModel.freeSong = sound.freeSong
                                            
                                            viewingSoundPlayer.toggle()
                                        }) {
                                            Text((sound.freeSong) ? "Tune-In" : "Membership Required")
                                                .padding()
                                                .font(.subheadline)
                                                .foregroundColor(Color(.white))
                                                .background(Color(.systemGray))
                                                .cornerRadius(20.0)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding()
                                .sheet(isPresented: $viewingSoundPlayer, content: {
                                    SingleSoundPlayerView()
                                })
                                
                                if isLoading {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .gray)).scaleEffect(3)
                                }
                                
                            }
                        }
                        
                    }.listStyle(InsetListStyle())
                    Banner()
                    
                }.tabItem { VStack {
                    Text("HOME")
                    Image(systemName: "house.fill")
                }}
                .onAppear(perform: {
                    loadData()
                    loadCategories()
                    print(categoryModelArray)
                })
                
                // Second Page
                OptionsView().tabItem {
                    VStack {
                        Text("Sleep Timer")
                        Image(systemName: "pause.fill")
                    }
                }
                // Third Page
                InAppStorePurchasesView().tabItem {
                    VStack {
                        Text("In-App Purchases")
                        Image(systemName: "pause.fill")
                    }
                }
                
            }.navigationTitle(Text("Nature FM"))
        }
    }
}


struct SoundsTableView_Previews: PreviewProvider {
    static var previews: some View {
        SoundsTableView().environmentObject(SoundsModel())
    }
}
