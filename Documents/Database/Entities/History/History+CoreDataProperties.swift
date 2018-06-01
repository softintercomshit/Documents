import Foundation
import CoreData


extension History {

    @nonobjc public class func getFetchRequest() -> NSFetchRequest<History> {
        let fetchRequest = NSFetchRequest<History>(entityName: "History")
        let sort = NSSortDescriptor(key: #keyPath(History.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        return fetchRequest
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var fullDate: NSDate?

    @NSManaged public var historyItem: NSOrderedSet?

}

// MARK: Generated accessors for historyItem
extension History {

    @objc(insertObject:inHistoryItemAtIndex:)
    @NSManaged public func insertIntoHistoryItem(_ value: HistoryItem, at idx: Int)

    @objc(removeObjectFromHistoryItemAtIndex:)
    @NSManaged public func removeFromHistoryItem(at idx: Int)

    @objc(insertHistoryItem:atIndexes:)
    @NSManaged public func insertIntoHistoryItem(_ values: [HistoryItem], at indexes: NSIndexSet)

    @objc(removeHistoryItemAtIndexes:)
    @NSManaged public func removeFromHistoryItem(at indexes: NSIndexSet)

    @objc(replaceObjectInHistoryItemAtIndex:withObject:)
    @NSManaged public func replaceHistoryItem(at idx: Int, with value: HistoryItem)

    @objc(replaceHistoryItemAtIndexes:withHistoryItem:)
    @NSManaged public func replaceHistoryItem(at indexes: NSIndexSet, with values: [HistoryItem])

    @objc(addHistoryItemObject:)
    @NSManaged public func addToHistoryItem(_ value: HistoryItem)

    @objc(removeHistoryItemObject:)
    @NSManaged public func removeFromHistoryItem(_ value: HistoryItem)

    @objc(addHistoryItem:)
    @NSManaged public func addToHistoryItem(_ values: NSOrderedSet)

    @objc(removeHistoryItem:)
    @NSManaged public func removeFromHistoryItem(_ values: NSOrderedSet)

}
