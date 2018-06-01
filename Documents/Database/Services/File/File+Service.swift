import Foundation
import CoreData


enum FileType: Int16 {
    case pdf = 0, png, unknouwn
    
    init(fileExtension: String) {
        switch fileExtension.lowercased() {
        case "pdf":
            self = .pdf
        case "png":
            self = .png
        default:
            self = .unknouwn
        }
    }
}

extension File {
    
    class func add(name: String, path: String) {
        let context = AccesLayer.shared.managedObjectContext

        let file = NSEntityDescription.insertNewObject(forEntityName: "File", into: context) as! File

        file.date = NSDate()
        file.name = name
        file.path = path
        
        let fileProperties = self.fileProperties(path: path)
        file.size = fileProperties.size
        file.type = fileProperties.type
        
        if let files = get() {
            let orderNumsArray = files.map{$0.order}
            var maxId = orderNumsArray.reduce(Int16.min, { max($0, $1) })
            maxId += 1
            file.order = maxId
        } else {
            file.order = 1
        }

        try? context.save()
    }
    
    func remove() {
        let context = AccesLayer.shared.managedObjectContext
        
        context.delete(self)
        try? context.save()
    }
    
    class func removeAll() {
        if let files = get() {
            for file in files {
                file.remove()
            }
        }
    }
    
    class func get() -> [File]? {
        let context = AccesLayer.shared.managedObjectContext
        let files = try? context.fetch(File.getFetchRequest())
        
        return files
    }
    
    private class func fileProperties(path: String) -> (size: Float, type: Int16) {
        if let attr = try? FileManager.default.attributesOfItem(atPath: path) {
            let size = attr[FileAttributeKey.size]
            let type = attr[FileAttributeKey.type]
            
//            return ()
//            FileType(fileExtension: path).rawValue
        }
        
        return (0, 0)
    }
}
