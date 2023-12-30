//
//  CatalogSubtitle.swift
//  natureFM
//
//  Created by Adam Reed on 12/28/23.
//

import SwiftUI

struct CatalogSubtitle: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
    }
}

struct CatalogSubtitle_Previews: PreviewProvider {
    static var previews: some View {
        CatalogSubtitle(text: "subtitle")
    }
}
