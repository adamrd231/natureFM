import Foundation
import SwiftUI

extension TimeInterval {
    func returnClockFormatAsString() -> String {
        let number = NSNumber(value: self)
        let minutes = Int(truncating: number) / 60
        let seconds = Int(truncating: number) % 60
        
        var returnedString = ""
        
        if seconds < 10 {
            returnedString = "\(minutes):0\(seconds)"
        } else {
            returnedString = "\(minutes):\(seconds)"
        }
        
        return returnedString
    }
}
