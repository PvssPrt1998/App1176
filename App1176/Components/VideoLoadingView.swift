import SwiftUI

struct VideoLoadingView: View {
    
    var isNotStroke: Bool = true
    let state: LoadingState
    @State var value = 0.1
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 87) {
            Text(text)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            if state == .loading {
                RoundedRectangle(cornerRadius: 20)
                    .fill(isNotStroke ?  Color.clear : Color.white)
                    .frame(width: 228, height: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isNotStroke ?  Color.clear : Color.c2547413)
                            .frame(width: max(0.1, min(value * 228, 228)))
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 326)
        .background(Color.c343434)
        .clipShape(.rect(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.c2547413, lineWidth: 2)
        )
        .onTapGesture {
            if state == .noConnection {
                value = 0.1
                stroke()
                action()
            }
        }
        .onAppear {
            if !isNotStroke {
                stroke()
            }
        }
    }
    
    private var text: String {
        switch state {
        case .loading: return "Loading"
        case .noConnection: return "Connection to server failed, tap to retry"
        case .loaded: return ""
        case .violateContent: return "You cannot generate 18+ content and content related to violence"
        }
    }
    
    func stroke() {
        withAnimation(.linear(duration: 1).repeatForever()) {
            value = 1
        }
    }
}

#Preview {
    VideoLoadingView(state: .loading, action: {})
        .padding()
}
