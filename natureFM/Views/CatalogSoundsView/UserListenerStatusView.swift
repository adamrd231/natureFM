//
//  UserListenerStatusView.swift
//  natureFM
//
//  Created by Adam Reed on 1/19/24.
//

import SwiftUI

struct UserListenerStatusView: View {
    let hasSubscription: Bool
    @Binding var tabSelection: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(hasSubscription ? "Member" : "Free Listener")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(hasSubscription ? "Thanks you for supporting natureFM" : "You could be missing out, get the subscription today for access to all content.")
                Button("Get subscription") {
                    tabSelection = 3
                }
                .buttonStyle(BorderButton(color: Color.theme.titleColor))
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct UserListenerStatusView_Previews: PreviewProvider {
    static var previews: some View {
        UserListenerStatusView(
            hasSubscription: true,
            tabSelection: .constant(3)
        )
    }
}
