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
    
    var mergeStartFrame: Data?
    var mergeEndFrame: Data?
    var mergeVideo: Video?
    var isMerge = false
    
    var randomPromtValue: Int = Int.random(in: 0..<5)
    var promtByText: (String,String,String) { //image, url, videoId
        switch randomPromtValue {
        default: return ("","https://storage.cdn-luma.com/dream_machine/77d7f933-e4a2-462d-b00e-a2471428d111/4fc4d114-6a51-4c02-887c-f4f743a052f0_video0ce31d3ef73434f7e81126fb590750c19.mp4","c8080624-30ba-4747-a41a-956a0d5d4bce")
        }
    }
    
    func imageToUrl(imageData: Data?, completion: @escaping (URL) -> Void, errorHandler: @escaping () -> Void) {
        guard let url = URL(string: "https://huggerapp.shop/api/upload"), let imageData = imageData, let uiImage = UIImage(data: imageData) else {
            print("Invalid URL for generateEffect.")
            errorHandler()
            return
        }
        
        let imageFilePath = save(image: uiImage)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        if let imageFilePath = imageFilePath {
            print(imageFilePath)
            do {
                let fileName = "image"
                let imageData = try Data(contentsOf: URL(fileURLWithPath: imageFilePath))
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileName)\"\r\n")
                body.append("Content-Type: image/jpeg\r\n\r\n")
                body.append(imageData)
                body.append("\r\n")
            } catch {
                errorHandler()
                return
            }
        } else {
            print("No image file provided.")
            errorHandler()
        }

        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        if let bodyString = String(data: body, encoding: .utf8) {
            print("Request body:\n\(bodyString)")
        }

        if let bodySize = request.httpBody?.count {
            print("HTTP Body size: \(bodySize) bytes")
        }
        
        print("before task")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("task stage 1")
            if let error = error {
                errorHandler()
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                errorHandler()
                return
            }
            print(httpResponse)

            guard (200...299).contains(httpResponse.statusCode) else {
                errorHandler()
                return
            }

            guard let data = data else {
                errorHandler()
                return
            }

            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw Response to generateEffect:\n\(rawResponse)")
            } else {
                print("Unable to parse raw response as string.")
            }

            do {
                let response = try JSONDecoder().decode(ImageResponse.self, from: data)
                if let url = URL(string: response.url) {
                    completion(url)
                } else {
                    errorHandler()
                }
            } catch {
                errorHandler()
            }
        }
        task.resume()
    }
    
    //MARK: - MERGE End frame and video
    func mergeEndFrameAndVideo(urlStr: String, completion: @escaping (_ response: Response?) -> Void, errorHandler: @escaping () -> Void) {
        guard let video = mergeVideo else { return }
        let parameters: [String: Any] = [
            "prompt": video.promt,
            "keyframes" : [
                "frame0" : [
                    "type" : "generation",
                    "id" : video.id
                ],
                "frame1" : [
                    "type" : "image",
                    "url" : urlStr
                ]
            ]
        ]
        
        guard let url =  URL(string: API.url) else { return }

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Keep-Alive", forHTTPHeaderField: "connection")
        request.addValue("Bearer " + API.key, forHTTPHeaderField: "authorization")
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          print("***************")
          print(request.httpBody)
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
            print("START ENCODE TO RESPONSE")
            let response = try JSONDecoder().decode(Response.self, from: responseData)
            print(response.id)
            if let failureReason = response.failureReason {
                if failureReason.count > 10 {
                    errorHandler()
                }
            } else {
                
                if let id = response.id, let promt = response.request.prompt, let createdAt = response.createdAt {
                    DispatchQueue.main.async {
                        self.saveVideo(Video(id: id, promt: promt, previewImageUrl: "", createdAt: createdAt))
                    }
                    print("VideoSaved")
                    //print(Video(id: response.id, promt: response.request.prompt, previewImageUrl: "", createdAt: response.createdAt))
                    completion(response)
                } else {
                    errorHandler()
                }
            }
            
        } catch let error {
          //print(error.localizedDescription)
            errorHandler()
            print("error: ", error)
        }
      }
      task.resume()
    }
    
    //MARK: - MERGE frame and video
    func mergeStartFrameAndVideo(urlStr: String, completion: @escaping (_ response: Response?) -> Void, errorHandler: @escaping () -> Void) {
        guard let video = mergeVideo else { return }
        let parameters: [String: Any] = [
            "prompt": video.promt,
            "keyframes" : [
                "frame0" : [
                    "type" : "image",
                    "url" : urlStr
                ],
                "frame1" : [
                    "type" : "generation",
                    "id" : video.id
                ]
            ]
        ]
        
        guard let url =  URL(string: API.url) else { return }

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Keep-Alive", forHTTPHeaderField: "connection")
        request.addValue("Bearer " + API.key, forHTTPHeaderField: "authorization")
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          print("***************")
          print(request.httpBody)
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
            print("START ENCODE TO RESPONSE")
            let response = try JSONDecoder().decode(Response.self, from: responseData)
            print(response.id)
            if let failureReason = response.failureReason {
                if failureReason.count > 10 {
                    errorHandler()
                }
            } else {
                
                if let id = response.id, let promt = response.request.prompt, let createdAt = response.createdAt {
                    DispatchQueue.main.async {
                        self.saveVideo(Video(id: id, promt: promt, previewImageUrl: "", createdAt: createdAt))
                    }
                    print("VideoSaved")
                    //print(Video(id: response.id, promt: response.request.prompt, previewImageUrl: "", createdAt: response.createdAt))
                    completion(response)
                } else {
                    errorHandler()
                }
            }
            
        } catch let error {
          //print(error.localizedDescription)
            errorHandler()
            print("error: ", error)
        }
      }
      task.resume()
    }
    
    func save(image: UIImage) -> String? {
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 0.5) {
           try? imageData.write(to: fileURL, options: .atomic)
            return fileURL.path // ----> Save fileName
        }
        print("Error saving image")
        return nil
    }

    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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
              if let image = jsonResponse.assets?.image, let id = jsonResponse.id {
                  DispatchQueue.main.async {
                      self.addPreviewImageLinkToVideo(id, url: image)
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
    
    //MARK: - postRequest startFrame and endFrame and text
    func postRequestTextWithEndFrameAndStartFrame(_ text: String, urlStr: String, urlStr1: String, aspectRatio: String? = nil, style: String, errorHandler: @escaping () -> Void, violateContent: @escaping () -> Void, completion: @escaping (_ response: Response?) -> ()) {
        print("Post request endFrame")
        
        let parameters: [String: Any] = [
            "prompt": style + text,
            "keyframes" : [
                "frame0" : [
                    "type" : "image",
                    "url" : urlStr
                ],
                "frame1" : [
                    "type" : "image",
                    "url" : urlStr1
                ]
            ],
            "aspectRatio" : aspectRatio ?? "16:9"
        ]
        
        guard let url =  URL(string: API.url) else { return }

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Keep-Alive", forHTTPHeaderField: "connection")
        request.addValue("Bearer " + API.key, forHTTPHeaderField: "authorization")
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          print("***************")
          print(request.httpBody)
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
            print("START ENCODE TO RESPONSE")
            let response = try JSONDecoder().decode(Response.self, from: responseData)
            print(response.id)
            if let failureReason = response.failureReason {
                if failureReason.count > 10 {
                    violateContent()
                }
            } else {
                
                if let id = response.id, let promt = response.request.prompt, let createdAt = response.createdAt {
                    DispatchQueue.main.async {
                        self.saveVideo(Video(id: id, promt: promt, previewImageUrl: "", createdAt: createdAt))
                    }
                    print("VideoSaved")
                    //print(Video(id: response.id, promt: response.request.prompt, previewImageUrl: "", createdAt: response.createdAt))
                    completion(response)
                } else {
                    errorHandler()
                }
            }
            
        } catch let error {
          //print(error.localizedDescription)
            errorHandler()
            print("error: ", error)
        }
      }
      task.resume()
    }
    
    //MARK: - postRequest endFrame and text
    func postRequestTextWithEndFrame(_ text: String, urlStr: String, aspectRatio: String? = nil, style: String, errorHandler: @escaping () -> Void, violateContent: @escaping () -> Void, completion: @escaping (_ response: Response?) -> ()) {
        
        print("Post request endFrame")
        
        let parameters: [String: Any] = [
            "prompt": style + text,
            "keyframes" : [
                "frame1" : [
                    "type" : "image",
                    "url" : urlStr
                ]
            ],
            "aspectRatio" : aspectRatio ?? "16:9"
        ]
        
        guard let url =  URL(string: API.url) else { return }

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Keep-Alive", forHTTPHeaderField: "connection")
        request.addValue("Bearer " + API.key, forHTTPHeaderField: "authorization")
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          print("***************")
          print(request.httpBody)
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
            print("START ENCODE TO RESPONSE")
            let response = try JSONDecoder().decode(Response.self, from: responseData)
            print(response.id)
            if let failureReason = response.failureReason {
                if failureReason.count > 10 {
                    violateContent()
                }
            } else {
                if let id = response.id, let promt = response.request.prompt, let createdAt = response.createdAt {
                    DispatchQueue.main.async {
                        self.saveVideo(Video(id: id, promt: promt, previewImageUrl: "", createdAt: createdAt))
                    }
                    print("VideoSaved")
                    //print(Video(id: response.id, promt: response.request.prompt, previewImageUrl: "", createdAt: response.createdAt))
                    completion(response)
                } else {
                    errorHandler()
                }
            }
            
        } catch let error {
          //print(error.localizedDescription)
            errorHandler()
            print("error: ", error)
        }
      }
      task.resume()
    }
    
    //MARK: - postRequest startImage and text
    func postRequestTextWithStartFrame(_ text: String, urlStr: String, aspectRatio: String? = nil, style: String, errorHandler: @escaping () -> Void, violateContent: @escaping () -> Void, completion: @escaping (_ response: Response?) -> ()) {
        print("Post request startFrame")
        
        let parametersModel = RequestWithFrames(promt: style + text, aspectRatio: aspectRatio, keyframes: KeyframesRequest(frame0: Frame0Request(type: "image", url: urlStr), frame1: nil))
        
        guard let parameters = try? JSONEncoder().encode(parametersModel) else {
            errorHandler()
            return
        }
        
        let parameters1: [String: Any] = [
            "prompt": style + text,
            "keyframes" : [
                "frame0" : [
                    "type" : "image",
                    "url" : urlStr
                ]
            ],
            "aspectRatio" : aspectRatio ?? "16:9"
        ]
        
        guard let url =  URL(string: API.url) else { return }

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Keep-Alive", forHTTPHeaderField: "connection")
        request.addValue("Bearer " + API.key, forHTTPHeaderField: "authorization")
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters1, options: .prettyPrinted)
          print("***************")
          print(request.httpBody)
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
            print("START ENCODE TO RESPONSE")
            let response = try JSONDecoder().decode(Response.self, from: responseData)
            print(response.id)
            if let failureReason = response.failureReason {
                if failureReason.count > 10 {
                    violateContent()
                }
            } else {
                if let id = response.id, let promt = response.request.prompt, let createdAt = response.createdAt {
                    DispatchQueue.main.async {
                        self.saveVideo(Video(id: id, promt: promt, previewImageUrl: "", createdAt: createdAt))
                    }
                    print("VideoSaved")
                    //print(Video(id: response.id, promt: response.request.prompt, previewImageUrl: "", createdAt: response.createdAt))
                    completion(response)
                } else {
                    errorHandler()
                }
            }
            
        } catch let error {
          //print(error.localizedDescription)
            errorHandler()
            print("error: ", error)
        }
      }
      task.resume()
    }
    
    //MARK: - postRequest
    func postRequestText(_ text: String, aspectRatio: String? = nil, style: String, errorHandler: @escaping () -> Void, violateContent: @escaping () -> Void, completion: @escaping (_ response: Response?) -> ()) {
        var parameters: [String: Any] = [
            "prompt": style + text
        ]
        
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
                if let id = response.id, let promt = response.request.prompt, let createdAt = response.createdAt {
                    DispatchQueue.main.async {
                        self.saveVideo(Video(id: id, promt: promt, previewImageUrl: "", createdAt: createdAt))
                    }
                    print("VideoSaved")
                    //print(Video(id: response.id, promt: response.request.prompt, previewImageUrl: "", createdAt: response.createdAt))
                    completion(response)
                } else {
                    errorHandler()
                }
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

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
