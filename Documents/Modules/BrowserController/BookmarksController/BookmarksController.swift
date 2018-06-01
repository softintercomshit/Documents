import UIKit

protocol BookmarksControllerDelegate: class {
    func didSelectBookmark(bookmark: Bookmarks)
    func didSelectHistoryItem(historyItem: HistoryItem)
}


final class BookmarksController: UIViewController, StoryboardInstantiable {
    static var storyboardName: String = "BookmarksController"
    
    internal enum DisplayType {
        case bookmarks, history
        
        var cellIdentifier: String {
            switch self {
            case .bookmarks:
                return "BookmarkCell"
            case .history:
                return "HistoryCell"
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak private var tableViewOutlet: UITableView!
    @IBOutlet private var editButton: UIBarButtonItem!
    
    // MARK: - Vars
    
    internal var displayType: DisplayType = .bookmarks
    weak var delegate: BookmarksControllerDelegate?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissController))
        tableViewOutlet.tableFooterView = UIView()
        registerCell(tableView: tableViewOutlet)
    }
    
    @objc internal func dismissController() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func displayTypeSegmentControlAction(_ sender: UISegmentedControl) {
        displayType = sender.selectedSegmentIndex == 0 ? .bookmarks : .history
        tableViewOutlet.reloadData()
        editButton.title = displayType == .bookmarks ? "Edit" : "Clear"
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        if displayType == .bookmarks {
            tableViewOutlet.setEditing(!tableViewOutlet.isEditing, animated: true)
        } else {
            clearHistory()
        }
    }
    
    private func clearHistory() {
        let message = "Clearing will remove history data. Clear from:"
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        let titles = ["The last hour",
                      "Today",
                      "Today and yesterday",
                      "All time"]
        
        for (idx, title) in titles.enumerated() {
            let action = UIAlertAction(title: title, style: .default) { _ in
                let option = History.ClearOption(rawValue: idx)!
                History.clearHistory(option: option)
                self.tableViewOutlet.reloadData()
            }
            
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
