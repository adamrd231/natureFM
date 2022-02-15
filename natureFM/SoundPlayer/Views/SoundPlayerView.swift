//
//  SoundPlayerView.swift
//  natureFM
//
//  Created by Adam Reed on 2/9/22.
//

import SwiftUI
import AVKit

struct SoundPlayerView: View {
    
    @State var audioPlayer = AVAudioPlayer()
    
    @Environment(\.presentationMode) var presentationMode

    @StateObject var playerVM: SoundPlayerViewModel
    
    @State var soundIsPlaying:Bool = false
    @State var currentTime: Int = 0
    @State var timer = Timer.publish(every: 1.0, on: .main, in: .common)
    
    
    init(sound: SoundsModel) {
        _playerVM = StateObject(wrappedValue: SoundPlayerViewModel(sound: sound))
    }
    
    func returnRemainingTime() -> Text {
        let remainingTime = Int(playerVM.audioPlayer.duration) - currentTime
        return Text(remainingTime.returnClockFormatAsString())
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.down")
                    }.foregroundColor(Color.theme.customBlue)
                    
                }.padding()
                
                SoundImageView(sound: playerVM.sound)
                    .frame(width: UIScreen.main.bounds.width)
                Text(playerVM.sound.name)
                    .font(.callout)
                    .fontWeight(.bold)
                    .padding(.top)
                
                
                // Sound Player tracker.
                VStack {
                    
                   
                    
                    HStack {
                        Text("\(currentTime.returnClockFormatAsString())")
                        Spacer()
                        returnRemainingTime()
                        Spacer()
                        Text("\(playerVM.audioPlayer.duration.returnClockFormatAsString())")
                        
                    }.padding()
                }
                .onReceive(timer, perform: { _ in
                    self.currentTime = Int(playerVM.audioPlayer.currentTime)
                })
               
                
                
                HStack(spacing: 25) {
                    Button(action: {
                        playerVM.audioPlayer.currentTime -= 30
                    }) {
                        Image(systemName: "gobackward.30")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    Button(action: {
                        if soundIsPlaying {
                            playerVM.audioPlayer.pause()
                            timer.connect().cancel()
                            soundIsPlaying = false
                        } else {
                            self.timer = Timer.publish(every: 1, on: .main, in: .common)
                            playerVM.audioPlayer.play()
                            timer.connect()
                            soundIsPlaying = true
                        }
                        
                    }) {
                        if soundIsPlaying {
                            Image(systemName: "pause.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                        } else {
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                       
                    }
                    Button(action: {
                        playerVM.audioPlayer.currentTime += 30
                    }) {
                        Image(systemName: "goforward.30")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }.foregroundColor(Color.theme.customBlue)
                
                Spacer()
            }
            
        }
        
       
    }
}

struct SoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerView(sound: SoundsModel())
    }
}
