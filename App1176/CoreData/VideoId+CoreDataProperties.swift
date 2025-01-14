import Foundation
import CoreData


extension VideoId {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoId> {
        return NSFetchRequest<VideoId>(entityName: "VideoId")
    }

    @NSManaged public var id: String

}

extension VideoId : Identifiable {

}
