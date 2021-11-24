//
//  SongPlayerFromFilesView.swift
//  natureFM
//
//  Created by Adam Reed on 11/24/21.
//

import SwiftUI
import AVKit

struct SongPlayerFromFilesView: View {
    
    // Core Data Manage Object Container
    @Environment(\.managedObjectContext) var managedObjectContext
    // Fetch request to get all categories from CoreData
    @FetchRequest(entity: PurchasedSubsciption.entity(), sortDescriptors: []) var purchasedSubsciption: FetchedResults<PurchasedSubsciption>
    
    
//    @State var currentURL: String
    @State var songName: String
    @State var freeSong: Bool
    var downloadManager = DownloadManagerFromFileManager()
    
    // Audio Player
    @State var player: AVPlayer?
    @State var playerItem: AVPlayerItem?

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
                    .disabled(freeSong == false)
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
                    if let unwrappedPlayer = player {
                        print("Current Player Item: \(String(describing: player?.currentItem))")
                        unwrappedPlayer.play()
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
                }) {
                    Image(systemName: "play.fill").resizable().frame(width: 25, height: 25, alignment: .center).foregroundColor(Color(.systemGray))
                }.disabled(freeSong == false && purchasedSubsciption.first?.hasPurchased != true)
                
                // Pause Button
                Button(action: {
                    player?.pause()
                    UIApplication.shared.isIdleTimerDisabled = false

                }) {
                    Image(systemName: "pause.fill").resizable().frame(width: 25, height: 25, alignment: .center).foregroundColor(Color(.systemGray))
                }.disabled(freeSong == false && purchasedSubsciption.first?.hasPurchased != true)
//                currentSound.freeSong == false && p
            }.padding(.bottom)
            
        }.padding()
        
        
        // Create the audio Player
        .onAppear(perform: {
            // Create URL String
                // Create the player item from URLString
            playerItem = downloadManager.getAudioFileAsset(urlName: songName)
            
            print("PlayerItem: \(playerItem?.asset)")
            // Add PlayerItem to Player
            player = AVPlayer(playerItem: playerItem)
//            let totalTime = currentSong.asset.duration
            let totalTime = playerItem?.asset.duration
            if let totalTime = totalTime {
                let floatTotalTime = CMTimeGetSeconds(totalTime)
                playerTotalTime = Int(floatTotalTime)
                print("Player Total Time is: \(playerTotalTime)")
            }
            
            // Add observer to the player to player information, like slider position, song position, etc.
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
        .opacity(freeSong == false && purchasedSubsciption.first?.hasPurchased == false ? 0.3 : 1.0)
    }
}

