//
//  SongPlayerView.swift
//  natureFM
//
//  Created by Adam Reed on 9/27/21.
//

import SwiftUI
import AVKit

struct SongPlayerView: View {
    
    // Core Data Manage Object Container
    @Environment(\.managedObjectContext) var managedObjectContext
    // Fetch request to get all categories from CoreData
    @FetchRequest(entity: PurchasedSubsciption.entity(), sortDescriptors: []) var purchasedSubsciption: FetchedResults<PurchasedSubsciption>
    
    
    @StateObject var currentSound: SoundsModel
    
    // Audio Player
    @State var player: AVPlayer?
    @State var audioPlayerItem: AVPlayerItem?
    @State var playerCurrentTime = 0
    @State var playerTotalTime = 0
    public var position: Int = 0
    
    @State var sliderValue = 0.0
    
    
    
    func converToClockFormat(time: Int) -> Text {
        if time % 60 > 9 {
            return Text("\(time / 60):\(time % 60)")
        } else {
            return Text("\(time / 60):0\(time % 60)")
        }
    }
    
    var body: some View {
        VStack {
            // Information Bar
            VStack {
                Text(currentSound.name).font(.title).bold()
                HStack {
                    Text("Location").bold()
                    Spacer()
                    Text("Category").bold()
                }
                HStack {
                    Text(currentSound.locationName).font(.caption)
                    Spacer()
                    Text(currentSound.categoryName).font(.caption)
                }
            }.padding(.bottom)
            
            // Slider
            VStack {
                Slider(value: Binding(
                            get: {
                                self.sliderValue
                            },
                            set: {(newValue) in
                                  self.sliderValue = newValue
                                player?.seek(to: CMTimeMakeWithSeconds(newValue, preferredTimescale: 1))
                                UIApplication.shared.isIdleTimerDisabled = true
                                  
                            }
                ), in: 0...Double(playerTotalTime))
                    .disabled(currentSound.freeSong == false)
                HStack {
                    converToClockFormat(time: playerCurrentTime).font(.caption)
                    Spacer()
                    converToClockFormat(time: playerTotalTime).font(.caption)
                }
            }
            
            
            // Play Pause Buttons
            HStack {
                // Play Button
                Button(action: {
                    if let unwrappedPlayer = self.player {
                        unwrappedPlayer.play()
                        UIApplication.shared.isIdleTimerDisabled = true
                        
                    }
                }) {
                    Image(systemName: "play.fill").resizable().frame(width: 25, height: 25, alignment: .center).foregroundColor(Color(.systemGray))
                }.disabled(currentSound.freeSong == false && purchasedSubsciption.first?.hasPurchased != true)
                
                // Pause Button
                Button(action: {
                    if let unwrappedPlayer = self.player {
                        unwrappedPlayer.pause()
                        UIApplication.shared.isIdleTimerDisabled = false
                        
                    }
                }) {
                    Image(systemName: "pause.fill").resizable().frame(width: 25, height: 25, alignment: .center).foregroundColor(Color(.systemGray))
                }.disabled(currentSound.freeSong == false && purchasedSubsciption.first?.hasPurchased != true)
//                currentSound.freeSong == false && p
            }.padding(.bottom)
            
        }.padding()
        
        
        // Create the audio Player
        .onAppear(perform: {
            
            // Create URL String
            guard let urlString = currentSound.audioFileLink else {
                print("URL is nil")
                return
            }
            // Test to see if the URL String is correct
            print(urlString)
            // Create the player item from URLString
            audioPlayerItem = AVPlayerItem(url: URL(string: urlString)!)
            // Add PlayerItem to Player
            player = AVPlayer(playerItem: audioPlayerItem)
            let totalTime = audioPlayerItem?.asset.duration
            let floatTotalTime = CMTimeGetSeconds(totalTime!)
            playerTotalTime = Int(floatTotalTime)
            
            // Add observer to the player to run the main function
            player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { (CMTime) -> Void in

                // Gather the current time of the player
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                // Assign the current time to the state variable
                playerCurrentTime = Int(time)
                
                // Check if the song has ended and replay it
                if playerCurrentTime >= playerTotalTime {
                    playerCurrentTime = 0
                    player?.seek(to: CMTimeMakeWithSeconds(Float64(playerCurrentTime), preferredTimescale: 1))
                }
                
                // Assign the current time to the slider value
                sliderValue = Double(playerCurrentTime)
            }
        })
        .onDisappear(perform: player?.pause)
        .onDisappear(perform: {
            UIApplication.shared.isIdleTimerDisabled = false
        })
        .opacity(currentSound.freeSong == false && purchasedSubsciption.first?.hasPurchased == false ? 0.3 : 1.0)
    }
}

