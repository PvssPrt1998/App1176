import SwiftUI

struct Splash: View {
    
    @EnvironmentObject var source: Source
    @State var value: Double = 0
    @Binding var screen: Screen
    @AppStorage("firstLaunch") var firstLaunch = true
    
    //@AppStorage("firstLaunch") var firstLaunch = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            Image("SplashLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 195, height: 195)
                .padding(.bottom, 65)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                .scaleEffect(2, anchor: .center)
                .frame(width: 82, height: 82)
                .padding(.bottom, 23)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
            stroke()
            source.load { loaded in
                if loaded {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        if !source.hasActiveSubscription() || firstLaunch {
                            firstLaunch = false
                            screen = .onboarding
                        } else {
                            screen = .main
                        }
                    }
                }
                
            }
        }
    }
    
    
    private func stroke() {
        
    }
}

struct Splash_Preview: PreviewProvider {
    
    @State static var splash: Screen = .splash
    
    static var previews: some View {
        Splash(screen: $splash)
            .environmentObject(Source())
    }
}
