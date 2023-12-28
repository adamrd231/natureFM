import SwiftUI

struct CatalogTitle: View {
    let title: String
    let color: Color?
    
    init(title: String, color: Color? = nil) {
        self.title = title
        self.color = color
    }
    var body: some View {
        Text(title)
            .foregroundColor(color)
            .font(.title2)
            .fontWeight(.bold)
    }
}

struct CatalogTitle_Previews: PreviewProvider {
    static var previews: some View {
        CatalogTitle(title: "Hallo", color: .blue)
    }
}
