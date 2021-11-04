//
//  HeaderView.swift
//  natureFM
//
//  Created by Adam Reed on 10/26/21.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("fall-leaves")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: .infinity, height: 150)
                .clipped()
                
            Color("pickerColor").frame(width: .infinity, height: 150).clipped()
            VStack(alignment: .center) {
                Text("Welcome to Nature FM").font(.title).foregroundColor(.white).bold()
                Text("Tune in to the great outdoors").font(.subheadline).foregroundColor(.white).bold().padding(.bottom)
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
