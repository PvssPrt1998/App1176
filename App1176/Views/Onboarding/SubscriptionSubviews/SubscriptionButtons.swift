import SwiftUI

struct SubscriptionButtons: View {
    
    @EnvironmentObject var source: Source
    @Binding var isYear: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            subscriptionButtonsTextYearly
            subscriptionButtonsTextWeekly
        }
    }
    
    private var subscriptionButtonsTextYearly: some View {
        HStack {
            Text(source.returnName(product: source.productsApphud[0]))
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("For only " + source.returnPrice(product: source.productsApphud[0]) + " " + source.returnPriceSign(product: source.productsApphud[0]))
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
        .frame(height: 61)
        .background(Color.c343434)
        .clipShape(.rect(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isYear ? Color.c2547413 : Color.c153153153, lineWidth: 2)
        )
        .onTapGesture {
            isYear = true
        }
        .frame(height: 71)
        .overlay(
            Text("Most Popular")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                .background(Color.black)
                .clipShape(.rect(cornerRadius: 40))
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.c25524035, lineWidth: 1)
                )
            ,alignment: .topTrailing
        )
    }
    
    private var subscriptionButtonsTextWeekly: some View {
        HStack {
            Text(source.returnName(product: source.productsApphud[1]))
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("For only " + source.returnPrice(product: source.productsApphud[1]) + " " + source.returnPriceSign(product: source.productsApphud[1]))
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 17))
        .frame(height: 61)
        .background(Color.c343434)
        .clipShape(.rect(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(!isYear ? Color.c2547413 : Color.c153153153, lineWidth: 2)
        )
        .onTapGesture {
            isYear = false
        }
    }
}
//
//#Preview {
//    SubscriptionButtons()
//        .environmentObject(Source())
//}
