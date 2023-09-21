//
//  TabItemView.swift
//  natureFM
//
//  Created by Adam Reed on 9/21/23.
//

import SwiftUI

struct TabItemView: View {
    let text: String
    let image: String
    var body: some View {
        VStack {
            Text(text)
            Image(systemName: image)
        }
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView()
    }
}
