import SwiftUI

struct CustomSubscriptionView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var source: Source
    @Binding var screen: Screen
    @State var isYear = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.c606060.ignoresSafeArea()
            Color.black.ignoresSafeArea(.container, edges: .bottom)
            VStack(spacing: 0) {
                Text("Subscription")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
                    .frame(height: 52)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.c606060)
                
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        
                        header
                        
                        SubscriptionDescription()
                        
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
                        
                        SubscriptionButtons(isYear: $isYear)
                            .padding(.top, 10)
                        
                        Button {
                            source.restorePurchase { bool in
                                if bool {
                                    screen = .onboarding
                                }
                            }
                        } label: {
                            Text("Restoring a purchase")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.c717171)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                        .padding(.top, 10)
                        
                        Button {
                            source.startPurchase(product: isYear ? source.productsApphud[0] : source.productsApphud[1]) { bool in
                                if bool {
                                    print("Subscription purchased")
                                    screen = .main
                                }
                            }
                        } label: {
                            Text("Continue")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.c2547413)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 16)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(
                Image("girlAndDog")
                    .resizable()
                    .scaledToFit()
                    .overlay(LinearGradient(colors: [.black.opacity(0), .black], startPoint: .top, endPoint: .bottom))
            ,alignment: .top)
            .background(Color.black)
        }
    }
    
//    private var subscriptionButtonsTextYearly: some View {
//        HStack {
//            Text(source.returnName(product: source.productsApphud[0]))
//                .font(.system(size: 20, weight: .regular))
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            Text("For only" + source.returnPrice(product: source.productsApphud[1]) + " " + source.returnPriceSign(product: source.product[1]))
//                .font(.system(size: 15, weight: .regular))
//                .foregroundColor(.white)
//        }
//        .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
//        .frame(height: 61)
//        .background(Color.c343434)
//        .clipShape(.rect(cornerRadius: 10))
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(isYear ? Color.c2547413 : Color.c153153153, lineWidth: 2)
//        )
//        .onTapGesture {
//            isYear = true
//        }
//        .frame(height: 71)
//        .overlay(
//            Text("Most Popular")
//                .font(.system(size: 15, weight: .regular))
//                .foregroundColor(.white)
//                .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
//                .background(Color.black)
//                .clipShape(.rect(cornerRadius: 40))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 40)
//                        .stroke(Color.c25524035, lineWidth: 1)
//                )
//            ,alignment: .topTrailing
//        )
//    }
//    
//    private var subscriptionButtonsTextWeekly: some View {
//        HStack {
//            Text(source.returnName(product: source.productsApphud[1]))
//                .font(.system(size: 20, weight: .regular))
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            Text("For only" + source.returnPrice(product: source.productsApphud[1]) + " " + source.returnPriceSign(product: source.product[1]))
//                .font(.system(size: 15, weight: .regular))
//                .foregroundColor(.white)
//        }
//        .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
//        .frame(height: 61)
//        .background(Color.c343434)
//        .clipShape(.rect(cornerRadius: 10))
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(!isYear ? Color.c2547413 : Color.c153153153, lineWidth: 2)
//        )
//        .onTapGesture {
//            isYear = false
//        }
//    }
    
//    private var subscriptionButtons: some View {
//        VStack(spacing: 8) {
//            subscriptionButtonsTextYearly
//            subscriptionButtonsTextWeekly
//        }
//    }
    
    private var header: some View {
        VStack(spacing: 0) {
            Text("Start Using Sora&Hug:\nAI Video Generator")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 28)
            
            Text("No commitment, cancel anytime.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.75))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 15)
        }
    }
}

struct CustomSubscriptionView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .onboarding
    
    static var previews: some View {
        CustomSubscriptionView(screen: $screen)
            .environmentObject(Source())
    }
    
    
}
