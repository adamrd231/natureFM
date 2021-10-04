//
//  SingleSoundPlayerView.swift
//  natureFM
//
//  Created by Adam Reed on 9/23/21.
//

import SwiftUI
import URLImage

struct SingleSoundPlayerView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var soundsModel: SoundsModel
    
    var body: some View {
        
        NavigationView {
            VStack() {
                // Image
                URLImage(URL(string: "\(soundsModel.imageFileLink)")!) { progress in
                    // Display progress
                    Image("placeholder").resizable().aspectRatio(contentMode: .fill)
                } content: { image in
                    // Downloaded image
                    image
                        .resizable()
                        .frame(minWidth: 100, idealWidth: .infinity, maxWidth: .infinity, minHeight: 250, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                }
                
                
               SongPlayerView()
                
                Spacer()
            }
            .navigationTitle(Text("\(soundsModel.name)"))
            .toolbar(content: {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Go Back")
                }
            })
            
        }
        
        
            
    }
}

struct SingleSoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSoundPlayerView().environmentObject(SoundsModel())
    }
}
