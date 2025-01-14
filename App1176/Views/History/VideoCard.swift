import SwiftUI
import Photos
import Combine

struct VideoCard: View {
    
    @EnvironmentObject var source: Source
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    let video: Video
    
    init(video: Video) {
        self.video = video
        self.imageLoader = ImageLoader(urlString: video.previewImageUrl)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(date)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 289, height: 289)
                .clipped()
                .background(Color.c606060)
                .clipShape(.rect(cornerRadius: 10))
                .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
                }
                .overlay(
                    HStack(spacing: 8) {
                        Button {
                            getVideoUrl()
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: 28, weight: .regular))
                                .foregroundColor(.white)
                                .frame(width: 34, height: 34)
                        }
                        Button {
                            source.removeVideoById(video.id)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 28, weight: .regular))
                                .foregroundColor(.white)
                                .frame(width: 34, height: 34)
                        }
                    }
                    .padding(8)
                    ,alignment: .topTrailing
                )
                .overlay(
                    Text(video.promt)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [.black.opacity(0), .black.opacity(1)], startPoint: .top, endPoint: .bottom))
                    ,alignment: .bottom
                )
        }
        .frame(width: 289)
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
    
    private var date: String {
        let array = String(video.createdAt.prefix(10)).components(separatedBy: "-")
        
        return array[2] + "." + array[1] + "." + array[0]
    }
}

#Preview {
    VideoCard(video: Video(id: "123", promt: "Guy", previewImageUrl: "https://storage.cdn-luma.com/dream_machine/77d7f933-e4a2-462d-b00e-a2471428d111/14ea06d7-ff2c-4752-9298-e0b4c376c474_video_0_thumb.jpg", createdAt: "Date"))
        .environmentObject(Source())
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, self != nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.data = data
            }
        }
        task.resume()
    }
}
