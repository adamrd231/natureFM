//
//  CategoryPickerView.swift
//  natureFM
//
//  Created by Adam Reed on 10/26/21.
//

import SwiftUI

struct CategoryPickerView: View {
    
    // State variable for currently selected category in category Enum
    @Binding var selectedCategory: CurrentCategory
    
    
    var body: some View {
        // Segmented Controller

            Picker("Favorite Color", selection: $selectedCategory, content: {
                            ForEach(CurrentCategory.allCases, content: { category in
                                Text(category.rawValue.capitalized).foregroundColor(Color.white)
                            })
            })
                .pickerStyle(SegmentedPickerStyle())
                .padding(.leading)
                .padding(.trailing)
    }
}


enum CurrentCategory: String, CaseIterable, Identifiable { // <1>
    case All
    case Outdoors
    case Waves
    case Rain
    case River
    case Waterfall
    case Lightning
    
    var id: CurrentCategory { self }
}
