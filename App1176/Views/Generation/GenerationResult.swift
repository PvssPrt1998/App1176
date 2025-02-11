import SwiftUI
import Photos
import AVKit

struct GenerationResult: View {
    
    @EnvironmentObject var source: Source
    @State private var player = AVPlayer()
    @Binding var screen: TabScreen
    @State var urlForSave: String?
    
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
                } else if loadingState == .violateContent {
                    //
                } else {
                    VideoLoadingView(isNotStroke: false, state: loadingState, value: 0.01) {
                        if !source.requestInProgress {
                            loadingState = .loading
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                request()
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 15, leading: 32, bottom: 0, trailing: 32))
                }
                
                
                VStack(spacing: 12) {
                    if loadingState == .loaded {
                    HStack(spacing: 8) {
                        Button {
                            loadingState = .loading
                            request()
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
                        
//                        Button {
//                            //
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
                        if let urlStr = urlForSave {
                            saveVideo(urlStr)
                        }
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
            if !source.requestInProgress {
                source.requestInProgress = true
                //mockRequest()
                if source.isMerge {
                    mergeRequest()
                } else {
                    request()
                }
            }
        }
    }
    
    private func mergeRequest() {
        if source.mergeStartFrame == nil {
            endFrameMergeRequest()
        } else {
            startFrameMergeRequest()
        }
    }
    
    private func endFrameMergeRequest() {
        source.imageToUrl(imageData: source.mergeStartFrame) { url in
            
            source.mergeEndFrameAndVideo(urlStr: url.absoluteString) { response in
                if let response = response, let id = response.id {
                    print("*****")
                    print("Response by id")
                    videoById(id)
                } else {
                    print("postRequest completion error cannot get response")
                    loadingState = .noConnection
                }
            } errorHandler: {
                loadingState = .noConnection
            }

        } errorHandler: {
            loadingState = .noConnection
        }
    }
    
    private func startFrameMergeRequest() {
        print("StartFrameRequest in view")
        source.imageToUrl(imageData: source.mergeStartFrame) { url in
            
            source.mergeStartFrameAndVideo(urlStr: url.absoluteString) { response in
                if let response = response, let id = response.id {
                    print("*****")
                    print("Response by id")
                    videoById(id)
                } else {
                    print("postRequest completion error cannot get response")
                    loadingState = .noConnection
                }
            } errorHandler: {
                loadingState = .noConnection
            }

        } errorHandler: {
            loadingState = .noConnection
        }
    }
    
    private func request() {
        if source.videoStartFrame == nil && source.videoEndFrame == nil {
            textRequest()
        } else if source.videoStartFrame != nil && source.videoEndFrame == nil {
            startFrameRequest()
        } else if source.videoStartFrame == nil && source.videoEndFrame != nil {
            endFrameRequest()
        } else {
            startAndEndFrameRequest()
        }
    }
    
    private func startFrameRequest() {
        print("StartFrameRequest in view")
        source.imageToUrl(imageData: source.videoStartFrame) { url in
            source.postRequestTextWithStartFrame(source.videoGenerationText, urlStr: url.absoluteString, aspectRatio: source.aspectRatio, style: source.style) {
                loadingState = .noConnection
            } violateContent: {
                loadingState = .noConnection
            } completion: { response in
                if let response = response, let id = response.id {
                    print("*****")
                    print("Response by id")
                    videoById(id)
                } else {
                    print("postRequest completion error cannot get response")
                    loadingState = .noConnection
                }
            }

        } errorHandler: {
            loadingState = .noConnection
        }
    }
    
    private func endFrameRequest() {
        source.imageToUrl(imageData: source.videoStartFrame) { url in
            source.postRequestTextWithEndFrame(source.videoGenerationText, urlStr: url.absoluteString, aspectRatio: source.aspectRatio, style: source.style) {
                loadingState = .noConnection
            } violateContent: {
                loadingState = .noConnection
            } completion: { response in
                if let response = response, let id = response.id {
                    print("*****")
                    print("Response by id")
                    videoById(id)
                } else {
                    print("postRequest completion error cannot get response")
                    loadingState = .noConnection
                }
            }
        } errorHandler: {
            loadingState = .noConnection
        }
    }
    
    private func startAndEndFrameRequest() {
        source.imageToUrl(imageData: source.videoStartFrame) { url1 in
            source.imageToUrl(imageData: source.videoEndFrame) { url2 in
                source.postRequestTextWithEndFrameAndStartFrame(source.videoGenerationText, urlStr: url1.absoluteString, urlStr1: url2.absoluteString, aspectRatio: source.aspectRatio, style: source.style) {
                    loadingState = .noConnection
                } violateContent: {
                    loadingState = .noConnection
                } completion: { response in
                    print("CompletionRequest")
                    if let response = response, let id = response.id {
                        print("*****")
                        print("Response by id")
                        videoById(id)
                    } else {
                        print("postRequest completion error cannot get response")
                        loadingState = .noConnection
                    }
                }
            } errorHandler: {
                loadingState = .noConnection
            }

        } errorHandler: {
            loadingState = .noConnection
        }

    }
    
    private func textRequest() {
        source.postRequestText(source.videoGenerationText, aspectRatio: source.aspectRatio, style: source.style) {
            loadingState = .noConnection
        } violateContent: {
            loadingState = .violateContent
        } completion: { response in
            print("CompletionRequest")
            if let response = response, let id = response.id {
                print("*****")
                print("Response by id")
                videoById(id)
            } else {
                print("postRequest completion error cannot get response")
                loadingState = .noConnection
            }
        }
    }
    
    private func videoById(_ id: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            source.videoById(id: id) { response in
                print(response)
                guard response?.state == "completed" else {
                    print("Video still generating")
                    videoById(id)
                    return
                }
                guard let strUrl = response?.assets?.video, let url = URL(string: strUrl) else {
                    loadingState = .noConnection
                    return
                }
                print("SetPlayer")
                setPlayer(url: url)
                loadingState = .loaded
            } errorHandler: {
                print("VideoById error error in getId method")
                loadingState = .noConnection
            }
        }
    }
    
    private func mockRequest() {
        source.videoById(id: "f3c98021-4814-446a-91ca-0b3e19637af2") { response in
            print(response)
            guard let strUrl = response?.assets?.video, let url = URL(string: strUrl) else {
                print("VideoById error cannot get response")
                loadingState = .noConnection
                return
            }
            print("SetPlayer")
            setPlayer(url: url)
            urlForSave = strUrl
            loadingState = .loaded
        } errorHandler: {
            print("VideoById error error in getId method")
            loadingState = .noConnection
        }
    }
    
    func setPlayer(url: URL) {
        player = AVPlayer(url: url)
        player.play()
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


struct GenerationResult_Preview: PreviewProvider {
    
    @State static var screen: TabScreen = .promtResult
    
    static var previews: some View {
        GenerationResult(screen: $screen)
            .environmentObject(Source())
    }
}
