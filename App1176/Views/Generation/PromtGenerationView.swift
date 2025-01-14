import SwiftUI
import Photos
import AVKit

struct PromtGenerationView: View {
    @EnvironmentObject var source: Source
    @State private var player = AVPlayer()
    @Binding var screen: TabScreen
    
    @State var loadingState: LoadingState = .loading
    
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
                    .isHidden(loadingState != .loaded)
                
                if loadingState == .loaded {
                    VideoPlayer(player: player)
                        .frame(height: 326, alignment: .center)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.top, 15)
                        .padding(.horizontal, 32)
                } else {
                    VideoLoadingView(state: loadingState) {
                        loadingState = .loading
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            checkConnection()
                        }
                    }
                    .padding(EdgeInsets(top: 15, leading: 32, bottom: 0, trailing: 32))
                }
                
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Button {
                            saveVideo(source.promtByText.1)
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
                        
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "bookmark")
//                                .font(.system(size: 15, weight: .regular))
//                                .foregroundColor(.white)
//                                .frame(width: 58, height: 34)
//                                .background(Color.c2547413)
//                                .clipShape(.rect(cornerRadius: 40))
//                        }
                    }
                    
                    Button {
                        screen = .videoImageGenerator
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
        .onAppear {
            checkConnection()
        }
    }
    
    func setPlayer(url: URL) {
        player = AVPlayer(url: url)
        player.play()
    }
    
    func checkConnection() {
        if let url = URL(string: source.promtByText.1) {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            URLSession(configuration: .default)
              .dataTask(with: request) { (_, response, error) -> Void in
                guard error == nil else {
                    loadingState = .noConnection
                  print("Error:", error ?? "")
                  return
                }

                guard (response as? HTTPURLResponse)?
                  .statusCode == 200 else {
                    loadingState = .noConnection

                    return
                }
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                      setPlayer(url: url)
                      loadingState = .loaded
                  }
              }
              .resume()
        }
    }
    func saveVideo(_ urlString: String) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: urlString),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/tempFile.mp4"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            print("Video is saved!")
                        }
                    }
                }
            }
        }
    }
}


struct PromtGenerationView_Preview: PreviewProvider {
    
    @State static var screen: TabScreen = .promtResult
    
    static var previews: some View {
        PromtGenerationView(screen: $screen)
            .environmentObject(Source())
    }
}
