import UIKit
import LTHPasscodeViewController


final class PasscodeLockController: UITableViewController, StoryboardInstantiable, LTHPasscodeViewControllerDelegate, SecurityQuestionsControllerDelegate {
    
    static var storyboardName: String = "PasscodeLockController"
    
    @IBOutlet private weak var passcodeLabel: UILabel!
    @IBOutlet private weak var changePasscodeLabel: UILabel!

    private let blueColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LTHPasscodeViewController.sharedUser().delegate = self
        
        let passcodeExists = LTHPasscodeViewController.doesPasscodeExist()
        passcodeLabel?.text = passcodeExists ? "Turn Passcode Off" : "Turn Passcode On"
        changePasscodeLabel?.textColor = passcodeExists ? blueColor : .lightGray
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if LTHPasscodeViewController.doesPasscodeExist() {
                LTHPasscodeViewController.sharedUser().showForDisablingPasscode(in: self, asModal: true)
            } else {
                let securityQuestionsController = SecurityQuestionsController.instantiate()
                securityQuestionsController.delegate = self
                present(UINavigationController(rootViewController: securityQuestionsController), animated: true, completion: nil)
            }
        case 1:
            if LTHPasscodeViewController.doesPasscodeExist() {
                LTHPasscodeViewController.sharedUser().showForChangingPasscode(in: self, asModal: true)
            }
        default:
            break
        }
    }
    
    func passcodeWasEnabled() {
        passcodeLabel?.text = "Turn Passcode Off"
        changePasscodeLabel?.textColor = blueColor
    }
    
    func deletePasscode() {
        LTHPasscodeViewController.sharedUser().delegate = nil
        LTHPasscodeViewController.deletePasscode()
        LTHPasscodeViewController.sharedUser().delegate = self
        passcodeLabel?.text = "Turn Passcode On"
        changePasscodeLabel?.textColor = .lightGray
        
        UserDefaults.standard.removeObject(forKey: "savedsecurityquestions")
        UserDefaults.standard.synchronize()
    }
    
    func didPressSave(controller: SecurityQuestionsController) {
        LTHPasscodeViewController.sharedUser().showForEnablingPasscode(in: self, asModal: true)
    }
}
