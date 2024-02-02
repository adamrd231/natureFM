//
//  CatalogSoundView.swift
//  natureFM
//
//  Created by Adam Reed on 2/1/24.
//

import SwiftUI

struct CatalogSoundView: View {
    let sound: SoundsModel
    let hasSubscription: Bool
    @ObservedObject var libraryVM: LibraryViewModel
    @Binding var tabSelection: Int
    @State var isViewingMenu: Bool = false
    @State var isShowingAlert: Bool = false
    
    var body: some View {
        HStack {
            SoundImageView(sound: sound)
                .frame(width: 100, height: 90)
                .cornerRadius(15)
                .clipped()
            SoundDetailStackView(sound: sound)
            
            Spacer()
            Button {
                isViewingMenu.toggle()
            } label: {
                Image(systemName: "menucard")
                    .padding()
            }
        }
        .sheet(isPresented: $isViewingMenu) {
            menu
            .presentationDetents([.fraction(0.25)])
        }
    }
}

struct CatalogSoundView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogSoundView(
            sound: dev.testSound,
            hasSubscription: false,
            libraryVM: dev.libraryVM,
            tabSelection: .constant(3)
        )
    }
}

extension CatalogSoundView {
    var menu: some View {
        VStack {
            List {
                Text(sound.name)
                    .bold()
                MenuRowView(
                    icon: "arrow.down.circle.fill",
                    text: libraryVM.mySounds.contains(sound) ? "In your library" : "Download sound to library",
                    action: {
                        if hasSubscription || sound.freeSong {
                            libraryVM.saveSoundToLibrary(sound)
                            isViewingMenu = false
                        } else {
                            isShowingAlert.toggle()
                        }
                    }
                )
            }
            .alert(isPresented: $isShowingAlert, content: {
                // decide which alert to show
                Alert(
                    title: Text("Currently not available"),
                    message: Text("You must have a subscription for this premium content."),
                    primaryButton: .default(Text("Store")) {
                        isViewingMenu = false
                        tabSelection = 3
                    },
                    secondaryButton: .cancel(Text("No thanks"))
                )
            })
            .listStyle(.plain)
            Button("Close") { isViewingMenu.toggle() }
                .padding()
        }
    }
}
