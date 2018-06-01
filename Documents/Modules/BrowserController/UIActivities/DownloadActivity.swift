import UIKit


final class DownloadActivity: UIActivity {
    
//    private override init() {}
    
    override var activityTitle: String? {
        return "Download"
    }
    
    override var activityType: UIActivityType? {
        return UIActivityType(rawValue: "Documents.Download")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override var activityImage: UIImage? {
        return nil
    }
    
    override func perform() {

    }
}

