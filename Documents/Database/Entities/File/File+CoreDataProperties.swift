import Foundation
import CoreData


extension File {

    @nonobjc public class func getFetchRequest() -> NSFetchRequest<File> {
        return NSFetchRequest<File>(entityName: "File")
    }

    @NSManaged public var path: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var order: Int16
    @NSManaged public var size: Float
    @NSManaged public var type: Int16

}
