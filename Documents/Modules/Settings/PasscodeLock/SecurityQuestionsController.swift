import Foundation
import DropDown

protocol SecurityQuestionsControllerDelegate: class {
    func didPressSave(controller: SecurityQuestionsController)
}


final class SecurityQuestionsController: UIViewController, StoryboardInstantiable {
    static var storyboardName: String = "SecurityQuestionsController"
    
    weak var delegate: SecurityQuestionsControllerDelegate?
    
    @IBOutlet private weak var securityQuestion1Button: UIButton!
    @IBOutlet private weak var securityQuestion2Button: UIButton!
    @IBOutlet private weak var securityQuestion3Button: UIButton!
    @IBOutlet private weak var answer1TextField: UITextField!
    @IBOutlet private weak var answer2TextField: UITextField!
    @IBOutlet private weak var answer3TextField: UITextField!
    
    private let questionsArray = [
        ["What is the first name of your best friend in high school?",
         "What was the name of your first pet?",
         "What was the first thing you learned to cook?",
         "What was the first film you saw in the theater?",
         "Where did you go the first time you flew on a plane?",
         "What is the last name of your favorite elementary school teacher?"
        ],
        ["What is your dream job?","What is your favorite children’s book?",
         "What was the model of your first car?",
         "What was your childhood nickname?",
         "Who was your favorite film star or character in school?",
         "Who was your favorite singer or band in high school?"
        ],
        ["In what city did your parents meet?",
         "What was the first name of your first boss?",
         "What is the name of the street where you grew up?",
         "What is the name of the first beach you visited?",
         "What was the first album that you purchased?",
         "What is the name of your favorite sports team?"
        ]
    ]
    
    private lazy var dropDown1: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = securityQuestion1Button
        dropDown.dataSource = questionsArray[0]
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.cellNib = UINib(nibName: "SecurityQuestionCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? SecurityQuestionCell else { return }
            
            cell.questionLabel.text = item
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.securityQuestion1Button.setTitle(item, for: .normal)
        }
        return dropDown
    }()
    
    private lazy var dropDown2: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = securityQuestion2Button
        dropDown.dataSource = questionsArray[1]
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.cellNib = UINib(nibName: "SecurityQuestionCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? SecurityQuestionCell else { return }
            
            cell.questionLabel.text = item
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.securityQuestion2Button.setTitle(item, for: .normal)
        }
        return dropDown
    }()
    
    private lazy var dropDown3: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = securityQuestion3Button
        dropDown.dataSource = questionsArray[2]
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.cellNib = UINib(nibName: "SecurityQuestionCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? SecurityQuestionCell else { return }
            
            cell.questionLabel.text = item
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.securityQuestion3Button.setTitle(item, for: .normal)
        }
        return dropDown
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveSecurityQuestions))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dimissController))
    }
    
    @objc private func dimissController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveSecurityQuestions() {
        guard let dropDown1Item = dropDown1.selectedItem,
            let dropDown2Item = dropDown2.selectedItem,
            let dropDown3Item = dropDown3.selectedItem else {
                Alert.show(title: "Warning", message: "Complete all fields please", actionNames: "OK", actionHandler: nil)
            return
        }
        
        guard let answer1 = answer1TextField.text, !answer1.isEmpty,
            let answer2 = answer2TextField.text, !answer2.isEmpty,
            let answer3 = answer3TextField.text, !answer3.isEmpty else {
                Alert.show(title: "Warning", message: "Complete all fields please", actionNames: "OK", actionHandler: nil)
            return
        }
        
        let dict = [dropDown1Item: answer1, dropDown2Item: answer2, dropDown3Item: answer3]
        UserDefaults.standard.set(dict, forKey: "savedsecurityquestions")
        UserDefaults.standard.synchronize()

        dismiss(animated: false) {
            self.delegate?.didPressSave(controller: self)
        }
    }
    
    @IBAction private func securityQuestion1Slected(_ sender: UIButton) {
        dropDown1.show()
    }
    
    @IBAction private func securityQuestion2Slected(_ sender: UIButton) {
        dropDown2.show()
    }
    
    @IBAction private func securityQuestion3Slected(_ sender: UIButton) {
        dropDown3.show()
    }
}
