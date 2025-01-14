import Foundation


final class DataManager {
    private let modelName = "DataModel"
    
    lazy var coreDataStack = CoreDataStack(modelName: modelName)
    
    func saveVideoId(_ id: String) {
        let videoId = VideoId(context: coreDataStack.managedContext)
        videoId.id = id
        coreDataStack.saveContext()
    }
    
    func saveVideo(_ video: Video) {
        let vcd = VideoCD(context: coreDataStack.managedContext)
        vcd.id = video.id
        vcd.createdAt = video.createdAt
        vcd.imageURL = video.previewImageUrl
        vcd.promt = video.promt
        coreDataStack.saveContext()
    }
    
    func removeVideo(_ id: String) throws {
        let videosCD = try coreDataStack.managedContext.fetch(VideoCD.fetchRequest())
        guard let videoCD = videosCD.first(where: {$0.id == id}) else { return }
        coreDataStack.managedContext.delete(videoCD)
        coreDataStack.saveContext()
    }
    
    func editVideo(_ video: Video) {
        do {
            let videosCD = try coreDataStack.managedContext.fetch(VideoCD.fetchRequest())
            videosCD.forEach { vcd in
                if vcd.id == video.id {
                    vcd.imageURL = video.previewImageUrl
                }
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchVideo() throws -> Array<Video> {
        var array: Array<Video> = []
        let videosCD = try coreDataStack.managedContext.fetch(VideoCD.fetchRequest())
        videosCD.forEach { vcd in
            array.append(Video(id: vcd.id, promt: vcd.promt, previewImageUrl: vcd.imageURL ?? "", createdAt: vcd.createdAt))
        }
        return array
    }
    
    func fetchVideoIds() throws -> Array<String> {
        var array: Array<String> = []
        let ids = try coreDataStack.managedContext.fetch(VideoId.fetchRequest())
        ids.forEach { videoId in
            array.append(videoId.id)
        }
        return array
    }
}
