import Foundation
import CoreData


extension Tab {
    
    class func add(name: String?, strUrl: String, iconUrl: String?) {
        let context = AccesLayer.shared.managedObjectContext
        
        let tab = NSEntityDescription.insertNewObject(forEntityName: "Tab", into: context) as! Tab
        tab.date = NSDate()
        tab.name = name
        tab.url = strUrl
        tab.iconUrl = iconUrl
        
        try? context.save()
    }
    
    func update(name: String?, strUrl: String, iconUrl: String?) {
        let context = AccesLayer.shared.managedObjectContext
        
        self.name = name
        self.url = strUrl
        self.iconUrl = iconUrl
        
        try? context.save()
    }
    
    func remove() {
        let context = AccesLayer.shared.managedObjectContext
        
        context.delete(self)
        try? context.save()
    }
    
    class func removeAll() {
        if let tabs = get() {
            for tab in tabs {
                tab.remove()
            }
        }
    }
    
    class func get() -> [Tab]? {
        let context = AccesLayer.shared.managedObjectContext
        let tabs = try? context.fetch(Tab.getFetchRequest())
        
        return tabs
    }
}
