import UIKit
import LTHPasscodeViewController
import DropDown


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LTHPasscodeViewControllerDelegate, AnswerSecurityQuestionsControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupMainWindow()
        setupPasscodeController()
        DropDown.startListeningToKeyboard()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if LTHPasscodeViewController.doesPasscodeExist() {
            LTHPasscodeViewController.sharedUser().delegate = self
        }
    }
    
    private func setupMainWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = TabBarController.instantiate()
        window?.makeKeyAndVisible()
    }
    
    private func setupPasscodeController() {
        LTHPasscodeViewController.sharedUser().hidesCancelButton = false
        LTHPasscodeViewController.useKeychain(false)
        LTHPasscodeViewController.sharedUser().maxNumberOfAllowedFailedAttempts = 1
        if LTHPasscodeViewController.doesPasscodeExist() {
            if LTHPasscodeViewController.didPasscodeTimerEnd() {
                LTHPasscodeViewController.sharedUser().showLockScreen(withAnimation: true, withLogout: false, andLogoutTitle: nil)
                LTHPasscodeViewController.sharedUser().delegate = self
            }
        }
    }
    
    func maxNumberOfFailedAttemptsReached() {
        if let presentationController = LTHPasscodeViewController.sharedUser().presentationController {
            let answerSecurityQuestionsController = AnswerSecurityQuestionsController.instantiate()
            answerSecurityQuestionsController.delegate = self
            presentationController.presentedViewController.present(UINavigationController(rootViewController: answerSecurityQuestionsController), animated: true, completion: nil)
        }
    }
    
    func didAnswerAllQuestions() {
        LTHPasscodeViewController.deletePasscodeAndClose()
    }
}
