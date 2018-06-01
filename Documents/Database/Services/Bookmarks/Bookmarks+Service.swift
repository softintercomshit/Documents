import Foundation
import CoreData


extension Bookmarks {
    
    class func add(name: String?, strUrl: String, iconUrl: String?) {
        let context = AccesLayer.shared.managedObjectContext
        
        let fetchRequest = NSFetchRequest<Bookmarks>(entityName: "Bookmarks")
        fetchRequest.predicate = NSPredicate(format: "url == %@", strUrl)
        let bookmarks = try? context.fetch(fetchRequest)
        
        guard let bookmarksArray = bookmarks, bookmarksArray.isEmpty else {
            return
        }
        
        let bookmark = NSEntityDescription.insertNewObject(forEntityName: "Bookmarks", into: context) as! Bookmarks
        
        bookmark.name = name
        bookmark.url = strUrl
        bookmark.iconUrl = iconUrl
        
        if let bookmarks = get() {
            let orderNumsArray = bookmarks.map{$0.order}
            var maxId = orderNumsArray.reduce(Int16.min, { max($0, $1) })
            maxId += 1
            bookmark.order = maxId
        } else {
            bookmark.order = 1
        }
        
        try? context.save()
    }
    
    func remove() {
        let context = AccesLayer.shared.managedObjectContext
        
        context.delete(self)
        try? context.save()
    }
    
    class func get() -> [Bookmarks]? {
        let context = AccesLayer.shared.managedObjectContext
        let bookmarks = try? context.fetch(Bookmarks.getFetchRequest())
        
        return bookmarks
    }
    
    class func reorder(source fromBookmark: Bookmarks, destination toBookmark: Bookmarks) {
        let tmp = fromBookmark
        fromBookmark.order = toBookmark.order
        toBookmark.order = tmp.order
        
        AccesLayer.shared.saveContext()
    }
}
