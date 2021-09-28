//
//  OptionsView.swift
//  natureFM
//
//  Created by Adam Reed on 9/27/21.
//

import SwiftUI

struct OptionsView: View {
    var body: some View {
            List() {
                Text("Screen will stay open while the sleep timer counts down, letting the phone go to sleep after you have.")
                HStack {
                    Text("Sleep Timer")
                    Spacer()
                    Text("Off")
                }
                HStack {
                    Spacer()
                    Text("2 Hours")
                }
                HStack {
                    Spacer()
                    Text("1 Hour")
                }
                HStack {
                    Spacer()
                    Text("30 Minutes")
                }
                HStack {
                    Spacer()
                    Text("15 Minutes")
                }
                HStack {
                    Spacer()
                    Text("10 Minutes")
                }
                HStack {
                    Spacer()
                    Text("5 Minutes")
                }
            }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
