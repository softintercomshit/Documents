import Foundation


final class DownloadsController: UIViewController, StoryboardInstantiable {
    
    static var storyboardName: String = "DownloadsController"
    
    // MARK: - Outlets
    
    // MARK: - Global vars
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Downloads"
    }
}
