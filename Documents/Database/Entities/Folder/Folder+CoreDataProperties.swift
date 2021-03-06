import Foundation
import CoreData


extension Folder {

    @nonobjc public class func getFetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var path: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var order: Int16
    @NSManaged public var size: Float
    @NSManaged public var files: NSSet?
    @NSManaged public var folders: NSSet?

}

// MARK: Generated accessors for files
extension Folder {

    @objc(addFilesObject:)
    @NSManaged public func addToFiles(_ value: File)

    @objc(removeFilesObject:)
    @NSManaged public func removeFromFiles(_ value: File)

    @objc(addFiles:)
    @NSManaged public func addToFiles(_ values: NSSet)

    @objc(removeFiles:)
    @NSManaged public func removeFromFiles(_ values: NSSet)

}

// MARK: Generated accessors for folders
extension Folder {

    @objc(addFoldersObject:)
    @NSManaged public func addToFolders(_ value: Folder)

    @objc(removeFoldersObject:)
    @NSManaged public func removeFromFolders(_ value: Folder)

    @objc(addFolders:)
    @NSManaged public func addToFolders(_ values: NSSet)

    @objc(removeFolders:)
    @NSManaged public func removeFromFolders(_ values: NSSet)

}
