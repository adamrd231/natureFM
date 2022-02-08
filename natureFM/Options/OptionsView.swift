//
//  OptionsView.swift
//  natureFM
//
//  Created by Adam Reed on 9/27/21.
//

import SwiftUI

struct OptionsView: View {
    
    @EnvironmentObject var sleepTimer: SleepTimer
   
    
    func updateSleepTimer(time: Int) {
        sleepTimer.time = time
        sleepTimer.usingSleepTimer = true
        print("time: \(sleepTimer.time)")
        print("bool: \(sleepTimer.usingSleepTimer)")
    }
    
    var body: some View {
            List() {
                HStack {
                    Text("Sleep Timer")
                    Text("\(sleepTimer.time)")
                    Spacer()
                    (sleepTimer.usingSleepTimer == true) ? Text("On") : Text("Off")
                }

                Button(action: {
                    updateSleepTimer(time: 7200)
                    
                }) {
                    Text("2 Hours")
                }
                
                Button(action: {
                    updateSleepTimer(time: 3600)
                }) {
                    Text("2 Hours")
                }
                Text("Screen will stay open while the sleep timer counts down, letting the phone go to sleep after you have. Future update for background playing coming soon").padding(.trailing)
            }
       
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(SleepTimer())
    }
}
