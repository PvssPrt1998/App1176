import Foundation
import CoreData


extension VideoCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoCD> {
        return NSFetchRequest<VideoCD>(entityName: "VideoCD")
    }

    @NSManaged public var id: String
    @NSManaged public var promt: String
    @NSManaged public var imageURL: String?
    @NSManaged public var createdAt: String

}

extension VideoCD : Identifiable {

}
