import SwiftUI
import ApphudSDK

struct OnboardingView: View {
    
    @State var selection = 0
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Binding var screen: Screen
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TabView(selection: $selection) {
                onboardingView1("Onboarding1").tag(0).gesture(DragGesture())
                onboardingView1("Onboarding2").tag(1).gesture(DragGesture())
                onboardingView1("Onboarding3").tag(2).gesture(DragGesture())
                onboardingView1("Onboarding4").tag(3).gesture(DragGesture())
                onboardingView2.tag(4).gesture(DragGesture())
            }
            .tabViewStyle(.page)
            .overlay(
                controlView.gesture(DragGesture())
                ,alignment: .bottom
            )
            .ignoresSafeArea()
        }
    }
    
    private func onboardingView1(_ image: String) -> some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea()
    }
    
    private var onboardingView2: some View {
        VStack(spacing: 0) {
            Color.c606060
                .frame(height: safeAreaInsets.top)
                .frame(maxWidth: .infinity)
            Color.c606060
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .overlay(
                    Text("Examples")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 16)
                    ,alignment: .leading
                )
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 17) {
                    Image("example1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 289, height: 289)
                    
                    Image("example2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 289, height: 289)
                    
                    Image("example3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 289, height: 289)
                    
                    Image("example4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 289, height: 289)
                }
                .padding(EdgeInsets(top: 41, leading: 0, bottom: 360, trailing: 0))
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(.container, edges: .top)
    }
    
    @ViewBuilder private var controlView: some View {
        ZStack {
            VStack(spacing: 0) {
                LinearGradient(colors: [.c217217217.opacity(0), .c373737], startPoint: .top, endPoint: .bottom)
                    .frame(height: 150)
                    .overlay(
                        onboarding1Overlay
                    )
                    .allowsHitTesting(false)
                Color.c373737
            }
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(textBySelection.0)
                        .font(.system(size: selection == 0 ? 22 : 34, weight: .bold))
                        .foregroundColor(.white)
                    Text(textBySelection.1)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.75))
                }
                .padding(.horizontal, 27)
                
                Button {
                    withAnimation {
                        if selection < 4 {
                            selection += 1
                        } else {
                            screen = .subscriptionView
                        }
                    }
                } label: {
                    Text("Continue")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(height: 53)
                        .frame(maxWidth: .infinity)
                        .background(Color.c2547413)
                        .clipShape(.rect(cornerRadius: 12))
                }
                .padding(.horizontal, 14)
            }
            .padding(.bottom, safeAreaInsets.bottom + 16)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(height: 365)
    }
    
    private var textBySelection: (String, String) {
        switch selection {
        case 0:
            return ("Turn Text to Video","with Sora&Hug: AI Video Generator you can turn your ideas into videos with just words")
        case 1:
            return ("Bring your photos to life","animate the photo and watch how the picture begins to move before your eyes")
        case 2:
            return ("Family videos","Look how a grandfather hugs his great-grandson. With our application you can turn your goals into reality and update your family archive")
        case 3:
            return ("Fantasies into reality","Turn all your ideas and fantasies into reality. Now there are no difficulties in implementing your own ideas")
        case 4:
            return ("Check out examples of generations","get inspired by examples")
        default:
            return ("Error1", "Error2")
        }
    }
    
    @ViewBuilder var onboarding1Overlay: some View {
        if selection == 0 {
            HStack(spacing: 0) {
                Text("Cat on a sle")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                
                Rectangle()
                    .fill(Color.c2547413)
                    .frame(width: 4)
            }
            .frame(height: 41)
            .padding(.horizontal, 25)
            .frame(height: 84)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.c454547)
            .clipShape(.rect(cornerRadius: 15))
            .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
        } else {
            EmptyView()
        }
    }
}

struct OnboardingView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .onboarding
    
    static var previews: some View {
        OnboardingView(screen: $screen)
    }
    
}
