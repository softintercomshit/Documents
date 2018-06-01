import UIKit


final class BookmarkActivity: UIActivity {
    private var name: String?
    private var strUrl: String?
    private var iconUrl: String?
    
    private override init() {}
    
    init(name: String?, strUrl: String, iconUrl: String?) {
        self.name = name
        self.strUrl = strUrl
        self.iconUrl = iconUrl
    }
    
    override var activityTitle: String? {
        return "Add to Bookmarks"
    }
    
    override var activityType: UIActivityType? {
        return UIActivityType(rawValue: "Documents.Bookmark")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override var activityImage: UIImage? {
        return nil
    }
    
    override func perform() {
        Bookmarks.add(name: name, strUrl: strUrl!, iconUrl: iconUrl)
    }
}
