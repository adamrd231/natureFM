//
//  SkeletonCatalogView.swift
//  natureFM
//
//  Created by Adam Reed on 2/2/24.
//

import SwiftUI

struct SkeletonCatalogView: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 100, height: 90)
                .cornerRadius(15)
                .clipped()
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 200, height: 15)
                    .cornerRadius(10)
                Rectangle()
                    .frame(width: 166, height: 15)
                    .cornerRadius(10)
                Rectangle()
                    .frame(width: 66, height: 15)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .foregroundColor(Color.theme.backgroundColor)
    }
}

struct SkeletonCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonCatalogView()
    }
}
