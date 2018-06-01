import Foundation
import CoreData


extension Folder {
    static private var documentDirectoryUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static var root: Folder {
        let fileManager = FileManager.default
        let filePath = documentDirectoryUrl.appendingPathComponent("root")
        if !fileManager.fileExists(atPath: filePath.path) {
            try? fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
        }
        
        let context = AccesLayer.shared.managedObjectContext
        let fetchRequest = NSFetchRequest<Folder>(entityName: "Folder")
        fetchRequest.predicate = NSPredicate(format: "path == \"root\"")
        
        if let folders = try? context.fetch(fetchRequest),
            let rootFolder = folders.first {
            
            return rootFolder
        }
        
        let folder = NSEntityDescription.insertNewObject(forEntityName: "Folder", into: context) as! Folder
        
        folder.path = "root"
        folder.date = NSDate()
        folder.name = "Home"
        folder.order = 1
        folder.size = 0
        
        try? context.save()
        
        return folder
    }
    
    class func add(name: String, parentFolder: Folder) {
        let context = AccesLayer.shared.managedObjectContext
        
        let folder = NSEntityDescription.insertNewObject(forEntityName: "Folder", into: context) as! Folder
        
        folder.date = NSDate()
        folder.name = name
        
        let fileManager = FileManager.default
        let filePath = documentDirectoryUrl.appendingPathComponent("\(parentFolder.path!)/\(name)")
        if !fileManager.fileExists(atPath: filePath.path) {
            try? fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
        }
        
        if let folders = get() {
            let orderNumsArray = folders.map{$0.order}
            var maxId = orderNumsArray.reduce(Int16.min, { max($0, $1) })
            maxId += 1
            folder.order = maxId
        } else {
            folder.order = 1
        }
        
        try? context.save()
    }
    
    func remove() {
        let context = AccesLayer.shared.managedObjectContext
        
        try? FileManager.default.removeItem(atPath: self.path!)
        
        context.delete(self)
        try? context.save()
    }
    
    class func removeAll() {
        if let folders = get() {
            for folder in folders {
                folder.remove()
            }
        }
    }
    
    class func get() -> [Folder]? {
        let context = AccesLayer.shared.managedObjectContext
        let folders = try? context.fetch(Folder.getFetchRequest())
        
        return folders
    }
}
