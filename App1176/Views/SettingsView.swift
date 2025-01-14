import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var source: Source
    @Binding var screen: Screen
    
    @State var text = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                Color.c606060.ignoresSafeArea()
                VStack(spacing: 0) {
                    Text("Settings")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
                        .frame(height: 52)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 0) {
                        Button {
                            if let url = URL(string: "https://docs.google.com/document/d/1JICKbmgYH-VS_E-H3HhDfSpWwTryHl43rUDEuUoiwM4/edit?usp=sharing") {
                                openURL(url)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Privacy Policy")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Image(systemName: "arrowtriangle.right.fill")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            .frame(height: 44)
                        }
                        .padding(.top, 40)
                        Rectangle()
                            .fill(Color.c606060)
                            .frame(height: 0.5)
                        Button {
                            if #available(iOS 18, *) {
                                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                    DispatchQueue.main.async {
                                        AppStore.requestReview(in: scene)
                                    }
                                }
                            } else {
                                SKStoreReviewController.requestReviewInCurrentScene()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Rate app")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Image(systemName: "arrowtriangle.right.fill")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            .frame(height: 44)
                        }
                        Rectangle()
                            .fill(Color.c606060)
                            .frame(height: 0.5)
//                        Button {
//                            
//                        } label: {
//                            HStack {
//                                Image(systemName: "square.and.arrow.up")
//                                    .font(.system(size: 20, weight: .semibold))
//                                    .foregroundColor(.white)
//                                Text("Share our app")
//                                    .font(.system(size: 17, weight: .regular))
//                                    .foregroundColor(.white)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                
//                                Image(systemName: "arrowtriangle.right.fill")
//                                    .font(.system(size: 15, weight: .regular))
//                                    .foregroundColor(.white)
//                            }
//                            .frame(height: 44)
//                        }
//                        Rectangle()
//                            .fill(Color.c606060)
//                            .frame(height: 0.5)
//                        
                        NavigationLink {
                            CurrentSubscriptionView(screen: $screen)
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Subscription details")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Image(systemName: "arrowtriangle.right.fill")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            .frame(height: 44)
                        }
                        Rectangle()
                            .fill(Color.c606060)
                            .frame(height: 0.5)
                        
                        Button {
                            if let url = URL(string: "https://docs.google.com/document/d/1GgPtQZtLTlEJqvtLdYCVcbNBXqN9xRBKSZMLOAfvadY/edit?usp=sharing") {
                                openURL(url)
                            }
                        } label: {
                            VStack(spacing: 0) {
                                HStack {
                                    Image(systemName: "house")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("Terms of Use")
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(height: 44)
                        }
                        
                        
                        Rectangle()
                            .fill(Color.c606060)
                            .frame(height: 0.5)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
                    .frame(maxHeight: .infinity)
                    .background(Color.black)
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
    func actionSheet() {
        guard let urlShare = URL(string: "https://google.com")  else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        if #available(iOS 15.0, *) {
            UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController?
            .present(activityVC, animated: true, completion: nil)
        } else {
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

struct SettingsView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .main
    
    static var previews: some View {
        SettingsView(screen: $screen)
            .environmentObject(Source())
    }
    
    
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
