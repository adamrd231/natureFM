import SwiftUI

struct LaunchScreenView: View {
    
    @State var loadingText: [String] = "Setting up Nature FM...".map { String($0)}
    @State var showLoadingText: Bool = false
    @State var counter: Int = 0
    @State var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        ZStack {
            Image("launchimage")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                .clipped()
            
            Color.theme.backgroundColor
                .opacity(0.66)
            
            VStack {
                Text("NatureFM")
                    .font(.system(size: 36))
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.titleColor)
    
                    if showLoadingText {
                        HStack(spacing: 0) {
                            ForEach(loadingText.indices) { index in
                                Text(loadingText[index])
                                    .font(.headline)
                                    .foregroundColor(Color.theme.titleColor)
                                    .fontWeight(.light)
                                    .offset(y: counter == index ? -5 : 0)
                                    
                            }
                        }
                        .transition(AnyTransition.scale.animation(.easeIn))
                    }
                
                
            }
            .onAppear(perform: {
                showLoadingText.toggle()
            })
            .onReceive(timer, perform: { _ in
                withAnimation(.spring()) {
                    let lastIndex = loadingText.count - 1
                    if counter >= lastIndex {
                        if loops >= 1 {
                            showLaunchView = false
                        }
                        counter = 0
                        loops += 1
                    } else {
                        counter += 1
                    }
                }
            })
            
        }.ignoresSafeArea()
        
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView(showLaunchView: .constant(true))
    }
}
