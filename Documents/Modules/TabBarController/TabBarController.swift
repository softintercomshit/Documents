import UIKit


final class TabBarController: UITabBarController, StoryboardInstantiable {
    
    static var storyboardName: String = TabBarController.identifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers = [
            FoldersController.instantiate().navigation,
            BrowserController.instantiate().navigation,
            DownloadsController.instantiate().navigation,
            SettingsController.instantiate().navigation
            ] as [UIViewController]
        
        let tabBarItems = [
            TabBarItem(title: "Folders", image: nil, selectedImage: nil),
            TabBarItem(title: "Browser", image: nil, selectedImage: nil),
            TabBarItem(title: "Downloads", image: nil, selectedImage: nil),
            TabBarItem(title: "More", image: nil, selectedImage: nil)
        ]
        
        for (idx, controller) in controllers.enumerated() {
            controller.tabBarItem = UITabBarItem(title: tabBarItems[idx].title, image: tabBarItems[idx].image, selectedImage: tabBarItems[idx].selectedImage)
        }
        
        viewControllers = controllers
    }
    
    private struct TabBarItem {
        let title: String?
        let image: UIImage?
        let selectedImage: UIImage?
    }
}

private extension UIViewController {
    var navigation: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
