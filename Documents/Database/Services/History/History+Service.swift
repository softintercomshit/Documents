import Foundation
import CoreData


extension History {
    
    class func add(name: String?, strUrl: String, iconUrl: String?) {
        let context = AccesLayer.shared.managedObjectContext
        
        let fetchRequest = NSFetchRequest<History>(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "date == %@", formatedDate())
        let historyArray = try? context.fetch(fetchRequest)
        
        if let historyArray = historyArray, let history = historyArray.first {
            let historyItem = HistoryItem.create(name: name, strUrl: strUrl, iconUrl: iconUrl, history: history)
            history.addToHistoryItem(historyItem)
        } else {
            let history = NSEntityDescription.insertNewObject(forEntityName: "History", into: context) as! History
            history.date = formatedDate()
            history.fullDate = NSDate()
            
            let historyItem = HistoryItem.create(name: name, strUrl: strUrl, iconUrl: iconUrl, history: history)
            history.addToHistoryItem(historyItem)
        }
        
        try? context.save()
    }
    
    func remove() {
        let context = AccesLayer.shared.managedObjectContext
        
        context.delete(self)
        try? context.save()
    }
    
    class func get() -> [History]? {
        let context = AccesLayer.shared.managedObjectContext
        let historyArray = try? context.fetch(History.getFetchRequest())
        
        if let historyArray = historyArray {
            for history in historyArray {
                let descriptor = NSSortDescriptor(key: "date", ascending: false)
                if let sortedArray = history.historyItem?.sortedArray(using: [descriptor]) {
                    history.historyItem = NSOrderedSet(array: sortedArray)
                }
            }
        }
        
        return historyArray
    }
    
    class func clearHistory(option: ClearOption) {
        switch option {
        case .lastHour:
            clearLastHour()
        case .today:
            clearTodayHistory()
        case .todayAndYesterday:
            clearTodayAndYesterdayHistory()
        case .allTime:
            clearAllHistory()
        }
    }
    
    private class func clearTodayHistory() {
        let context = AccesLayer.shared.managedObjectContext
        
        let fetchRequest = NSFetchRequest<History>(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "date == %@", formatedDate())
        if let historyArray = try? context.fetch(fetchRequest), let history = historyArray.first {
            history.remove()
        }
    }
    
    private class func clearTodayAndYesterdayHistory() {
        let context = AccesLayer.shared.managedObjectContext
        
        let fetchRequest = NSFetchRequest<History>(entityName: "History")
        
        
        let calendar = Calendar.current
        let date: Date = formatedDate() as Date
        
        if let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: date) {
            fetchRequest.predicate = NSPredicate(format: "date >= %@", yesterdayDate as NSDate)
            
            if let historyArray = try? context.fetch(fetchRequest), let history = historyArray.first {
                history.remove()
            }
        }
    }
    
    private class func clearAllHistory () {
        if let historyArray = get() {
            let context = AccesLayer.shared.managedObjectContext
            
            for history in historyArray {
                context.delete(history)
            }
            
            try? context.save()
        }
    }
    
    private class func clearLastHour() {
        let context = AccesLayer.shared.managedObjectContext
        
        let fetchRequest = NSFetchRequest<History>(entityName: "History")
        
        
        let calendar = Calendar.current
        
        if let lastHour = calendar.date(byAdding: .hour, value: -1, to: Date()) {
            fetchRequest.predicate = NSPredicate(format: "fullDate >= %@", lastHour as NSDate)
            
            if let historyArray = try? context.fetch(fetchRequest), let history = historyArray.first {
                history.remove()
            }
        }
    }
    
    private class func formatedDate() -> NSDate {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        let formatedDate = calendar.date(from: dateComponents)
    
        return formatedDate! as NSDate
    }
}
