import Foundation
import CoreData


extension Bookmarks {

    @nonobjc public class func getFetchRequest() -> NSFetchRequest<Bookmarks> {
        let fetchRequest = NSFetchRequest<Bookmarks>(entityName: "Bookmarks")
        let sort = NSSortDescriptor(key: #keyPath(Bookmarks.order), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        return fetchRequest
    }

    @NSManaged public var name: String?
    @NSManaged public var order: Int16
    @NSManaged public var url: String?
    @NSManaged public var iconUrl: String?

}
