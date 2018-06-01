import Foundation
import CoreData


extension Tab {

    @nonobjc public class func getFetchRequest() -> NSFetchRequest<Tab> {
        let fetchRequest = NSFetchRequest<Tab>(entityName: "Tab")
        let sort = NSSortDescriptor(key: #keyPath(Tab.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        return fetchRequest
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var iconUrl: String?
    @NSManaged public var date: NSDate?

}
