import Foundation
import CoreData


extension HistoryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryItem> {
        return NSFetchRequest<HistoryItem>(entityName: "HistoryItem")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var url: String?
    @NSManaged public var iconUrl: String?
    @NSManaged public var history: History?

}
