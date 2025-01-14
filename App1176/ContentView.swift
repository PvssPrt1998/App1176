import SwiftUI

struct ContentView: View {
    
    @State var screen: Screen = .splash
    @EnvironmentObject var source: Source
    
    @State var tabScreen: TabScreen = .promtResult
    var body: some View {
        switch screen {
        case .splash:
            Splash(screen: $screen)
        case .main:
            Tab(screen: $screen)
        case .onboarding:
            OnboardingView(screen: $screen)
        case .subscriptionView:
            CustomSubscriptionView(screen: $screen)
        case .rateScreen:
            RateView(screen: $screen)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Source())
}

