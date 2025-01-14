import Foundation
import SwiftUI
import ApphudSDK

final class Source: ObservableObject {//luma-82fc55d1-8727-426e-9a43-823f8e255839-1ea8c544-234e-482f-9ec2-f89aa7cd8da8

    var productsApphud: Array<ApphudProduct> = []
    private var paywallID = "main"
    //@AppStorage("responseData1") var responseData1: Data = Data()
    let dataManager = DataManager()
    var currentVideo: Int?
    var videoIds: Array<String> = []
    @Published var videos: Array<Video> = []
    
    var requestInProgress = false
    
    var style: String = ""
    var aspectRatio: String = "16:9"
    var videoGenerationText: String = ""
    var videoStartFrame: Data?
    var videoEndFrame: Data?
    
    var randomPromtValue: Int = Int.random(in: 0..<5)
    var promtByText: (String,String,String) { //image, url, videoId
        switch randomPromtValue {
        default: return ("","https://storage.cdn-luma.com/dream_machine/77d7f933-e4a2-462d-b00e-a2471428d111/4fc4d114-6a51-4c02-887c-f4f743a052f0_video0ce31d3ef73434f7e81126fb590750c19.mp4","c8080624-30ba-4747-a41a-956a0d5d4bce")
        }
    }
    
    @MainActor func load(completion: @escaping (Bool) -> Void) {
        if let ids = try? dataManager.fetchVideoIds() {
            videoIds = ids
        }
        if let videos = try? dataManager.fetchVideo() {
            self.videos = videos
        }
        loadPaywalls { value in
            completion(value)
        }
    }
    
    func videoById(id: String, completion: @escaping (_ response: Response?) -> (), errorHandler: @escaping () -> Void) {
        guard let url = URL(string: API.url + "/" + id) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + API.key, forHTTPHeaderField: "authorization")
        let task = session.dataTask(with: request) { data, response, error in
          if let error = error {
              
            //print("Post Request Error: \(error.localizedDescription)")
              print(error)
              errorHandler()
            return
          }
          
          // ensure there is valid response code returned from this HTTP response
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
          else {
            print("Invalid Response received from the server")
              errorHandler()
            return
          }
          
          // ensure there is data returned
          guard let responseData = data else {
              errorHandler()
            print("nil Data received from the server")
            return
          }

          do {
            // create json object from data or use JSONDecoder to convert to Model stuct
            let jsonResponse = try JSONDecoder().decode(Response.self, from: responseData)
              let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any]
              print("Video by id check")
              print(responseData)
              print(json)
              completion(jsonResponse)
              if let image = jsonResponse.assets?.image {
                  DispatchQueue.main.async {
                      self.addPreviewImageLinkToVideo(jsonResponse.id, url: image)
                  }
              }
              
          } catch let error {
            print(error.localizedDescription)
              print(error)
          }
        }
        
        task.resume()
    }
    
    func addPreviewImageLinkToVideo(_ id: String, url: String) {
        guard let index = videos.firstIndex(where: {$0.id == id}) else { return }
        videos[index].previewImageUrl = url
        dataManager.editVideo(videos[index])
    }

    func requestUrlByImage(_ imageData: Data) {
        let imageTest = UIImage(named: "example1")!.jpegData(compressionQuality: 1)
        guard let image = UIImage(data: imageData) else { return }
        let url = URL(string: "https://huggerapp.shop/api/upload")
        let session = URLSession.shared
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = imageTest
        
              let task = session.dataTask(with: urlRequest) { data, response, error in
                  if let error = error {
                      print("Post Request Error: \(error.localizedDescription)")
                      return
                  }
        
                // ensure there is valid response code returned from this HTTP response
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode)
                else {
                  print("Invalid Response received from the server")
                  return
                }
        
                // ensure there is data returned
                guard let responseData = data else {
                  print("nil Data received from the server")
                  return
                }
                  print(responseData)
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: responseData)
                    print(jsonResponse)

                  // create json object from data or use JSONDecoder to convert to Model stuct
                } catch let error {
                  //print(error.localizedDescription)
                    print("error: ", error)
                }
              }
              // perform the task
              task.resume()
    }
    
    func requestVideoByTextAndStartFrame() {
        
    }
    
    func requestVideoByTextAndEndFrame() {
        
    }
    
    func requestVideoByTextAndFrames() {
        
    }
    
    //MARK: - postRequest
    func postRequestText(_ text: String, aspectRatio: String? = nil, style: String, errorHandler: @escaping () -> Void, violateContent: @escaping () -> Void, completion: @escaping (_ response: Response?) -> ()) {
        var parameters: [String: Any] = ["prompt": style + text]
        if let aspectRatio = aspectRatio {
            parameters.updateValue("aspect_ratio", forKey: aspectRatio)
        }
        guard let url =  URL(string: API.url) else { return }

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + API.key, forHTTPHeaderField: "authorization")
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      } catch let error {
        print(error.localizedDescription)
        return
      }
      // create dataTask using the session object to send data to the server
      let task = session.dataTask(with: request) { data, response, error in
          if let error = error {
              print("Post Request Error: \(error.localizedDescription)")
              errorHandler()
              return
          }
        
        // ensure there is valid response code returned from this HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
          print("Invalid Response received from the server")
            errorHandler()
          return
        }
        
        // ensure there is data returned
        guard let responseData = data else {
            errorHandler()
          print("nil Data received from the server")
          return
        }
        
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: responseData)
            print(jsonResponse)
            let response = try JSONDecoder().decode(Response.self, from: responseData)
            print(response.id)
            if let failureReason = response.failureReason {
                if failureReason.count > 10 {
                    violateContent()
                }
            } else {
                self.saveVideo(Video(id: response.id, promt: response.request.prompt, previewImageUrl: "", createdAt: response.createdAt))
                print("VideoSaved")
                print(Video(id: response.id, promt: response.request.prompt, previewImageUrl: "", createdAt: response.createdAt))
                completion(response)
            }
            
        } catch let error {
          //print(error.localizedDescription)
            errorHandler()
            print("error: ", error)
        }
      }
      task.resume()
    }
    
    func saveVideo(_ video: Video) {
        videos.append(video)
        dataManager.saveVideo(video)
    }
    
    @MainActor
    func loadPaywalls(completion: @escaping (Bool) -> Void) {
        Apphud.paywallsDidLoadCallback { paywalls, arg in
            if let paywall = paywalls.first(where: {$0.identifier == self.paywallID}) {
                Apphud.paywallShown(paywall)
                let products = paywall.products
                self.productsApphud = products
                completion(products.count >= 2 ? true : false)
            }
        }
    }
    
    @MainActor
    func restorePurchase(escaping: @escaping (Bool) -> Void) {
        print("restore")
        Apphud.restorePurchases { subscriptions, _, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                escaping(false)
            }
            if subscriptions?.first?.isActive() ?? false {
                escaping(true)
            }
            if Apphud.hasActiveSubscription() {
                escaping(true)
            }
        }
    }
    
    @MainActor
    func returnPrice(product: ApphudProduct) -> String {
        return product.skProduct?.price.stringValue ?? ""
    }
    
    @MainActor
    func returnPriceSign(product: ApphudProduct) -> String {
        return product.skProduct?.priceLocale.currencySymbol ?? ""
    }
    
    @MainActor
    func returnName(product: ApphudProduct) -> String {
        guard let subscriptionPeriod = product.skProduct?.subscriptionPeriod else { return "" }
        
        switch subscriptionPeriod.unit {
        case .day:
            return "Weekly"
        case .week:
            return "Weekly"
        case .month:
            return "Monthly"
        case .year:
            return "Yearly"
        @unknown default:
            return "Unknown"
        }
    }
    
    @MainActor
    func startPurchase(product: ApphudProduct, escaping: @escaping(Bool)->Void) {
        let selectedProduct = product
        Apphud.purchase(selectedProduct) { result in
            if let error = result.error {
                debugPrint(error.localizedDescription)
                escaping(false)
            }
            debugPrint(result)
            if let subscription = result.subscription, subscription.isActive() {
                escaping(true)
            } else if let purchase = result.nonRenewingPurchase, purchase.isActive() {
                escaping(true)
            } else {
                if Apphud.hasActiveSubscription() {
                    escaping(true)
                }
            }
        }
    }
    
    func removeVideoById(_ id: String) {
        guard let index = videos.firstIndex(where: {$0.id == id}) else { return }
        videos.remove(at: index)
        try? dataManager.removeVideo(id)
    }
    
    @MainActor
    func hasActiveSubscription() -> Bool {
        Apphud.hasActiveSubscription()
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

//Optional(682 bytes)
//Optional(<NSHTTPURLResponse: 0x600000230920> { URL: https://api.lumalabs.ai/dream-machine/v1/generations/719d000e-2c0d-4348-ab8c-17fd58931691 } { Status Code: 200, Headers {
//    "Content-Length" =     (
//        682
//    );
//    "Content-Type" =     (
//        "application/json"
//    );
//    Date =     (
//        "Thu, 26 Dec 2024 08:50:51 GMT"
//    );
//    Server =     (
//        uvicorn
//    );
//} })
//["id": 719d000e-2c0d-4348-ab8c-17fd58931691, "state": completed, "created_at": 2024-12-26T08:36:58.236000Z, "failure_reason": <null>, "assets": {
//    image = "https://storage.cdn-luma.com/dream_machine/13845236-1e63-4b22-a3d0-dbad32c8996d/baa866f0-3f1d-4831-a9ba-a9e9c40b2626_video_0_thumb.jpg";
//    video = "https://storage.cdn-luma.com/dream_machine/13845236-1e63-4b22-a3d0-dbad32c8996d/458e0d4c-c1ba-4963-a115-2263ed6f9406_video0b7c5d7b7a8fa4339a8a0a6e81b03717e.mp4";
//}, "model": ray-1-6, "generation_type": video, "request": {
//    "aspect_ratio" = "16:9";
//    "callback_url" = "<null>";
//    "generation_type" = video;
//    keyframes = "<null>";
//    loop = 0;
//    prompt = "an old lady laughing underwater, wearing a scuba diving suit";
//}]
