import UIKit
import StoreKit
import MessageUI


final class SettingsController: UITableViewController, StoryboardInstantiable {

    static var storyboardName: String = "SettingsController"
    private let kAppID = "843233267"
    private let kEmailRecipients = ["ivan.postolaki@gmail.com"]
    
    @IBOutlet private weak var searchEngineLabel: UILabel!
    @IBOutlet private weak var userAgentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchEngineLabel?.text = SearchEngine.selected.name
        userAgentLabel?.text = UserAgent.selected.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        navigationController?.navigationBar.topItem?.titleView = nil
        navigationController?.navigationBar.topItem?.title = "More"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            print("buy pro")
        case (1, 0):
            sendMail()
        case (1, 1):
            if let cell = tableView.cellForRow(at: indexPath) {
                ShareAppManager.shared.shareApp(appId: kAppID, controller: self, cell: cell)
            }
        case (1, 2):
            SICAds.show()
        case (1, 3):
            rateApp()
        case (2, 0):
            let passcodeLockController = PasscodeLockController.instantiate()
            navigationController?.pushViewController(passcodeLockController, animated: true)
        case (3, 0):
            showSearchEngineActionSheet()
        case (3, 1):
            showUserAgentActionSheet()
        case (3, 2):
            showClearHistoryActionSheet()
        default:
            break
        }
    }
    
    private func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            let strUrl = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(kAppID)"
            if let url = URL(string: strUrl) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    private func showSearchEngineActionSheet() {
        let actionSheetController = UIAlertController(title: "Search Engine", message: nil, preferredStyle: .actionSheet)
        
        for searchEngine in SearchEngine.engines {
            let action = UIAlertAction(title: searchEngine.name, style: .default, handler: { (action) in
                searchEngine.save()
                self.searchEngineLabel?.text = searchEngine.name
            })
            
            if searchEngine.name == SearchEngine.selected.name {
                action.setValue(true, forKey: "checked")
            }
            actionSheetController.addAction(action)
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelActionButton)

        present(actionSheetController, animated: true, completion: nil)
    }
    
    private func showClearHistoryActionSheet() {
        let actionSheetController = UIAlertController(title: "Clearing will remove history, cookies and other browsing data.", message: nil, preferredStyle: .actionSheet)
        
        let clearActionButton = UIAlertAction.init(title: "Clear", style: .destructive) { (action) in
            History.clearHistory(option: .allTime)
        }
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(clearActionButton)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    private func showUserAgentActionSheet() {
        let actionSheetController = UIAlertController(title: "User Agent", message: nil, preferredStyle: .actionSheet)
        
        for userAgent in UserAgent.agents {
            let action = UIAlertAction(title: userAgent.name, style: .default, handler: { (action) in
                if userAgent.name == "Custom" {
                    self.showCustomUserAgentAlert()
                } else {
                    userAgent.save()
                    self.userAgentLabel?.text = userAgent.name
                }
            })
            
            if userAgent.name == UserAgent.selected.name {
                action.setValue(true, forKey: "checked")
            }
            actionSheetController.addAction(action)
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelActionButton)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    private func showCustomUserAgentAlert() {
        let alertController = UIAlertController(title: "User Agent", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Mozilla/5.0 (Mobile; rv:26.0) Gecko/26.0 Firefox/26.0"
            textField.text = UserAgent.custom.value
        })
        
        let okActionButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            let textField = alertController.textFields![0] as UITextField
            
            let customUserAgent = UserAgent(name: "Custom", value: textField.text ?? "")
            UserAgent.saveCustom(userAgent: customUserAgent)
            customUserAgent.save()
            self.userAgentLabel?.text = customUserAgent.name
        })
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelActionButton)
        alertController.addAction(okActionButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SettingsController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    private func sendMail() {
        let currSysVer = UIDevice.current.systemVersion
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
        let currDeiceVer = UIDevice.current.modelName() ?? ""
        var appName = ""
        if let infoDictionary = Bundle.main.infoDictionary,
            let appNameResult = infoDictionary[kCFBundleNameKey as String] as? String {
            
            appName = appNameResult
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        composeVC.setToRecipients(kEmailRecipients)
//        composeVC.setSubject("")
        composeVC.setMessageBody("********************\nDevice: \(currSysVer)\nModel: \(currDeiceVer)\nApplication Version: \(currentVersion)\nApplication Name: \(appName)\n\n********************", isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            present(composeVC, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(composeVC, animated: true)
        }
    }
}
