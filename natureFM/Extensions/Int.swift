import Foundation

extension Int {
    
    
    func returnClockFormatAsString() -> String {
        let number = NSNumber(value: self)
        let minutes = Int(number) / 60
        let seconds = Int(number) % 60
        
        var returnedString = ""
        
        if seconds < 10 {
            returnedString = "\(minutes):0\(seconds)"
        } else {
            returnedString = "\(minutes):\(seconds)"
        }
        
        return returnedString
    }
    
}

