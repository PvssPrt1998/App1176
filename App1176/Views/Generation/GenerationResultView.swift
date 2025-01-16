import SwiftUI
import AVKit

struct GenerationResultView: View {
    @EnvironmentObject var source: Source
    @State private var player = AVPlayer()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.c606060.ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Generate")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
                    .frame(height: 52)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.c606060)
                
                Text("Result")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 28)
                    .padding(.horizontal, 32)
                VideoPlayer(player: AVPlayer(url: URL(string: "https://storage.cdn-luma.com/dream_machine/77d7f933-e4a2-462d-b00e-a2471428d111/4fc4d114-6a51-4c02-887c-f4f743a052f0_video0ce31d3ef73434f7e81126fb590750c19.mp4")!))
                    .frame(height: 326, alignment: .center)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.top, 15)
                    .padding(.horizontal, 32)
                
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Button {

                        } label: {
                            HStack {
                                Image(systemName: "wand.and.stars.inverse")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)

                                Text("Remake")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                            .background(Color.c2547413)
                            .clipShape(.rect(cornerRadius: 40))
                        }
                        Button {

                        } label: {
                            Image(systemName: "bookmark")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                                .frame(width: 58, height: 34)
                                .background(Color.c2547413)
                                .clipShape(.rect(cornerRadius: 40))
                        }
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)

                            Text("Save")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 34)
                        .background(Color.c2547413)
                        .clipShape(.rect(cornerRadius: 40))
                    }
                    Button {

                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)

                            Text("Back")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 34)
                        .background(Color.c2547413)
                        .clipShape(.rect(cornerRadius: 40))
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal, 32)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.black)

        }
    }
}


#Preview {
    GenerationResultView()
        .environmentObject(Source())
}
