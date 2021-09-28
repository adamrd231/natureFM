//
//  SongPlayerView.swift
//  natureFM
//
//  Created by Adam Reed on 9/27/21.
//

import SwiftUI
import AVKit

struct SongPlayerView: View {
    
    @EnvironmentObject var soundsModel: SoundsModel
    
    
    @State var audioPlayer: AVAudioPlayer!
    @State var audioPlayerItem: AVPlayerItem?
    
    // Audio Player
    @State var player: AVPlayer?
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
                HStack {
                    Text("Location").bold()
                    Spacer()
                    Text("Category").bold()
                }
                HStack {
                    Text("\(soundsModel.locationName)").font(.caption)
                    Spacer()
                    Text("\(soundsModel.categoryName)").font(.caption)
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
                                  
                            }
                ), in: 0...Double(playerTotalTime)).disabled(soundsModel.freeSong == false)
                HStack {
                    converToClockFormat(time: playerCurrentTime).font(.caption)
                    Spacer()
                    converToClockFormat(time: playerTotalTime).font(.caption)
                }
            }
            
            
            // Play Pause Buttons
            HStack {
                Button(action: {
                    if let unwrappedPlayer = self.player {
                        unwrappedPlayer.play()
                    }
                }) {
                    Image(systemName: "play.fill").resizable().frame(width: 25, height: 25, alignment: .center).foregroundColor(Color(.systemGray))
                }.disabled(soundsModel.freeSong == false)
                
                // Sound Player
                Button(action: {
                    if let unwrappedPlayer = self.player {
                        unwrappedPlayer.pause()
                    }
                }) {
                    Image(systemName: "pause.fill").resizable().frame(width: 25, height: 25, alignment: .center).foregroundColor(Color(.systemGray))
                }.disabled(soundsModel.freeSong == false)
            }.padding(.bottom)
        }.padding()
        
        
        // Create the audio Player
        .onAppear(perform: {
            
            // Create URL String
            guard let urlString = soundsModel.audioFileLink else {
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
            
            player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                print("Test")
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                playerCurrentTime = Int(time)
                
                sliderValue = Double(playerCurrentTime)
                // Replay the timer when song ends
                if playerCurrentTime == playerTotalTime {
                    player?.seek(to: CMTimeMake(value: 0, timescale: 1))
                }
            
            }
        })
        
        .opacity(!soundsModel.freeSong ? 0.3 : 1.0)
    }
}

struct SongPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SongPlayerView().environmentObject(SoundsModel())
        
    }
}
