import Foundation
import LTHPasscodeViewController


protocol AnswerSecurityQuestionsControllerDelegate: class {
    func didAnswerAllQuestions()
}


final class AnswerSecurityQuestionsController: UIViewController, StoryboardInstantiable {
    
    static var storyboardName: String = "AnswerSecurityQuestionsController"
    weak var delegate: AnswerSecurityQuestionsControllerDelegate?
    
    @IBOutlet private var securityQuestionsButton: [UIButton]!
    @IBOutlet private var answersTextField: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unlock", style: .done, target: self, action: #selector(answerQuestions))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dimissController))
        
        if let dict = UserDefaults.standard.object(forKey: "savedsecurityquestions") as? [String: String] {
            for (offset: idx, element: (key: key, value: _)) in dict.enumerated() {
                _ = securityQuestionsButton.map {
                    if $0.tag == idx {
                        $0.setTitle(key, for: .normal)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        answersTextField[0].becomeFirstResponder()
    }
    
    @objc private func answerQuestions() {
        if let dict = UserDefaults.standard.object(forKey: "savedsecurityquestions") as? [String: String] {
            print(dict)
            for button in securityQuestionsButton {
                for textField in answersTextField {
                    if textField.tag == button.tag {
                        if let answer = textField.text, !answer.isEmpty,
                            let question = button.title(for: .normal),
                            let rightAnswer = dict[question] {

                            if answer != rightAnswer {
                                let alertController = Alert.new(title: "Error", message: "Wrong answer", buttons: "OK")
                                present(alertController, animated: true, completion: nil)
                                return
                            }
                        } else {
                            let alertController = Alert.new(title: "Warning", message: "Comaplete all fields.", buttons: "OK")
                            present(alertController, animated: true, completion: nil)
                            return
                        }
                    }
                }
            }

            dismiss(animated: false) {
                self.delegate?.didAnswerAllQuestions()
            }
        }
    }
    
    @objc private func dimissController() {
        dismiss(animated: true, completion: nil)
    }
}
