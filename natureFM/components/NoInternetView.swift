//
//  NoInternetView.swift
//  natureFM
//
//  Created by Adam Reed on 1/23/24.
//

import SwiftUI

struct NoInternetView: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 25, height: 25)
            Text("No internet connection available")
                .bold()
            Text("To view sounds and download items from the library, please connect to wifi or cellular data.")
                .font(.caption)
            Button {
                tabSelection = 2
            } label: {
                Text("Library")
            }
            .tint(Color.black.opacity(0.4))
            .buttonStyle(.bordered)

        }
        .padding()
        .background(Color.theme.backgroundColor)
        .foregroundColor(Color.theme.titleColor)
        .cornerRadius(10)
        .padding()
        .multilineTextAlignment(.center)
    }
}

struct NoInternetView_Previews: PreviewProvider {
    static var previews: some View {
        NoInternetView(tabSelection: .constant(1))
    }
}
