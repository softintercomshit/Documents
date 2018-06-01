import Foundation
import CoreData


extension HistoryItem {
    
    class func create(name: String?, strUrl: String, iconUrl: String?, history: History) -> HistoryItem {
        let context = AccesLayer.shared.managedObjectContext
        
        let fetchRequest = NSFetchRequest<HistoryItem>(entityName: "HistoryItem")
        fetchRequest.predicate = NSPredicate(format: "url == %@ and history == %@", strUrl, history)
        let historyItems = try? context.fetch(fetchRequest)
        
        if let historyItems = historyItems,
            let historyItem = historyItems.first {
            
            historyItem.date = NSDate()
            historyItem.name = name
            historyItem.iconUrl = iconUrl
            try? context.save()
            
            return historyItem
        }
        
        let historyItem = NSEntityDescription.insertNewObject(forEntityName: "HistoryItem", into: context) as! HistoryItem
        
        historyItem.name = name
        historyItem.iconUrl = iconUrl
        historyItem.url = strUrl
        historyItem.date = NSDate()
        
        try? context.save()
        
        return historyItem
    }
    
    func remove() {
        let context = AccesLayer.shared.managedObjectContext
        let history = self.history
        
        history?.removeFromHistoryItem(self)
        
        if let history = history, history.historyItem?.count == 0 {
            history.remove()
        }
        
        try? context.save()
    }
}
