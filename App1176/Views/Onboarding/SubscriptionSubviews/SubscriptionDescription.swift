import SwiftUI

struct SubscriptionDescription: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(spacing: 8) {
                Text("⏸️️")
                    .font(.system(size: 20, weight: .regular))
                Text("Make Ai Videos From Text")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
            }
            HStack(spacing: 8) {
                Text("🖼️")
                    .font(.system(size: 20, weight: .regular))
                Text("Animate Still Photos")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
            }
            HStack(spacing: 8) {
                Text("⛔️")
                    .font(.system(size: 20, weight: .regular))
                Text("No Ads Or Watermark")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 15)
        .frame(maxWidth: .infinity,alignment: .leading)
    }
}

#Preview {
    SubscriptionDescription()
}
