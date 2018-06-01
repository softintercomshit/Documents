import Foundation
import CoreData

@objc(History)
public class History: NSManagedObject {
    
    enum ClearOption: Int {
        case lastHour, today, todayAndYesterday, allTime
    }

}
