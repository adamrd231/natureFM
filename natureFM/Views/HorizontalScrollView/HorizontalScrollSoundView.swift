//
//  HorizontalScrollSoundView.swift
//  natureFM
//
//  Created by Adam Reed on 1/19/24.
//

import SwiftUI

struct HorizontalScrollSoundView: View {
    let sound: SoundsModel
    let hasSubscription: Bool
    let userOwnsSound: Bool
    @Binding var isViewingSongPlayerTab: Bool
    @Binding var tabSelection: Int
    
    @State var showingAlert: Bool = false
    
    var body: some View {
        // This should be it's own component
        VStack(alignment: .leading, spacing: 5) {
            SoundImageView(sound: sound)
//                .frame(width: 250, height: 150)
                .frame(width: 300, height: 150)
                .clipped()
                .shadow(radius: 5)

            HStack {
                Button(action: {
                    if sound.freeSong || hasSubscription {
                        // Download sound is allowed
                    } else {
                        showingAlert.toggle()
                        // Could prompt user to subscription page
                    }
                }) {
                    HStack(spacing: 5) {
                        if userOwnsSound {
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .fontWeight(.bold)
                            Text("Download")
                                .font(.caption2)
                        } else {
                            Text("In your library")
                                .font(.caption2)
                        }
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                }
                .disabled(userOwnsSound)
                .buttonStyle(BorderButton(color: Color.theme.titleColor))
                Spacer()
                Button(action: {
                    if sound.freeSong || hasSubscription {
                        // Download sound is allowed
                    } else {
                        showingAlert.toggle()
                        // Could prompt user to subscription page
                    }
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .fontWeight(.bold)
                        Text("Listen")
                            .font(.caption2)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .buttonStyle(BorderButton(color: Color.theme.titleColor))
            }
            .padding(.vertical, 5)
            .foregroundColor(Color.theme.titleColor)
            
            Text(sound.name).bold()
            Text("length: \(sound.duration.returnClockFormatAsString())")
                .foregroundColor(Color.theme.titleColor.opacity(0.66))
            Text(sound.categoryName)
                .foregroundColor(Color.theme.titleColor.opacity(0.66))
            Text(sound.freeSong ? "Free" : "Subscription")
                .padding(.horizontal, 7)
                .padding(.vertical, 4)
                .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue)
        }
        .font(.caption)
        .alert(isPresented: $showingAlert, content: {
            // decide which alert to show
            Alert(
                title: Text("Currently not available"),
                message: Text("You must have a subscription for this premium content."),
                primaryButton: .default(Text("Store")) {
                    tabSelection = 3
                },
                secondaryButton: .cancel(Text("No thanks"))
            )
            
        })
        .frame(maxWidth: 300)
    }
}

struct HorizontalScrollSoundView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollSoundView(
            sound: dev.testSound,
            hasSubscription: false,
            userOwnsSound: true,
            isViewingSongPlayerTab: .constant(true),
            tabSelection: .constant(2)
        )
    }
}
