import SwiftUI

struct RateView: View {
    
    @Binding var screen: Screen
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct RateView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .rateScreen
    
    static var previews: some View {
        RateView(screen: $screen)
    }
}
