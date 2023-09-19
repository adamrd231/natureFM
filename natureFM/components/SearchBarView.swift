import SwiftUI

struct SearchBarView: View {
    
    // Current search text variable for user input
    @Binding var currentSearchText: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $currentSearchText)
                
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            Button("Close") {
                UIApplication.shared.endEditing()
            }.foregroundColor(Color(.systemGray))
        }
        .padding(.leading)
        .padding(.trailing)
    }
}



extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

