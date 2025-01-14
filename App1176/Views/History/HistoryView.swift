import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var source: Source
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                Color.c606060.ignoresSafeArea()
                VStack(spacing: 0) {
                    Text("Generation history")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
                        .frame(height: 52)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.c606060)
                    
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            if source.videos.isEmpty {
                                Text("The history of your\ngenerations is preserved\nhere")
                                    .font(.system(size: 28, weight: .regular))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 70)
                                    .frame(maxHeight: .infinity, alignment: .top)
                            } else {
                                LazyVStack(spacing: 16) {
                                    ForEach(source.videos, id: \.self) { video in
                                        NavigationLink {
                                            HistoryVideo(video: video)
                                        } label: {
                                            VideoCard(video: video)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 15, leading: 30, bottom: 16, trailing: 30))
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color.black)
            }
        }
    }
}

struct HistoryView_Preview: PreviewProvider {
    
    static var previews: some View {
        HistoryView()
            .environmentObject(Source())
    }
}
