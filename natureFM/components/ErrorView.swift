//
//  ErrorView.swift
//  natureFM
//
//  Created by Adam Reed on 2/2/24.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.theme.backgroundColor)
            VStack(alignment: .leading, spacing: 10) {
                Text("Error")
                    .bold()
                
                Text(error)
                Text("Please re-load app and check internet connection.")
                    .font(.footnote)
            }
            .padding()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(
            error: "This is the error message"
        )
    }
}
