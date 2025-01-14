import SwiftUI
import Photos
import AVKit

struct HistoryVideo: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var source: Source
    @State private var player = AVPlayer()
    let video: Video
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
                
                Text(video.promt)
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
                    VideoLoadingView(isNotStroke: true, state: loadingState) {
                        loadingState = .loading
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            getVideoById()
                        }
                    }
                    .padding(EdgeInsets(top: 15, leading: 32, bottom: 0, trailing: 32))
                }
                
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Button {
                            getVideoUrl()
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
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
                        self.presentationMode.wrappedValue.dismiss()
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
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear {
            getVideoById()
        }
    }
    
    func setPlayer(url: URL) {
        player = AVPlayer(url: url)
        player.play()
    }
    
    func getVideoUrl() {
        source.videoById(id: video.id) { response in
            print(response)
            guard let strUrl = response?.assets?.video, let url = URL(string: strUrl) else {
                print("VideoById error cannot get response")
                return
            }
            saveVideo(strUrl)
        } errorHandler: {
            print("VideoById error error in getId method")
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
    
    func getVideoById() {
        source.videoById(id: video.id) { response in
            guard let strUrl = response?.assets?.video, let url = URL(string: strUrl) else {
                loadingState = .noConnection
                return
            }
            print("SetPlayer")
            setPlayer(url: url)
            loadingState = .loaded
        } errorHandler: {
            loadingState = .noConnection
        }
    }
}


//struct HistoryVideo_Preview: PreviewProvider {
//    
//    @State static var screen: TabScreen = .promtResult
//    
//    static var previews: some View {
//        HistoryVideo(, video: Video)
//            .environmentObject(Source())
//    }
//}
