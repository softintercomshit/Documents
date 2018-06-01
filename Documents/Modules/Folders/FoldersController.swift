import UIKit
import Zip


final class FoldersController: UIViewController, StoryboardInstantiable, UISearchResultsUpdating, UITextFieldDelegate {

    static var storyboardName: String = "FoldersController"
    
    // MARK: - Outlets
    
    @IBOutlet weak var toolbarHeight: NSLayoutConstraint! {
        didSet {
            toolbarHeight.constant = 0
        }
    }
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.autocapitalizationType = .none
        }
    }
    @IBOutlet private weak var sortByButton: UIButton!
    
    // MARK: - Global vars
    
    private var createActionButton: UIAlertAction?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Folder.root.name
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
            
            let search = UISearchController(searchResultsController: nil)
            search.accessibilityActivate()
            search.searchResultsUpdater = self
            navigationItem.searchController = search
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchBar
        }
        
        tableView.allowsMultipleSelectionDuringEditing = true
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    // MARK: - setEditing table view
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)
        toolbarHeight.constant = editing ? 44 : 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        
        if editing {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "All", style: .done, target: self, action: #selector(selectAllItems(sender:)))
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc private func selectAllItems(sender: UIBarButtonItem) {
        func selectAll() {
            for row in 0..<tableView.numberOfRows(inSection: 0) {
                let indexPath = IndexPath(row: row, section: 0)
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
        
        func deselectAll() {
            for row in 0..<tableView.numberOfRows(inSection: 0) {
                let indexPath = IndexPath(row: row, section: 0)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        if let indexPathsForSelectedRows = tableView.indexPathsForSelectedRows {
            if indexPathsForSelectedRows.count == 20 {
                deselectAll()
            } else {
                selectAll()
            }
        } else {
            selectAll()
        }
    }
    
    // MARK: - Butons actions
    
    @IBAction func sortByAction(_ sender: UIButton) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let items = ["Sort by name", "Sort by date", "Sort by size", "Sort by type", "Custom"]
        for item in items {
            let action = UIAlertAction(title: item, style: .default, handler: { (action) in
                print(item)
            })
            
            if item == "Sort by name" {
                action.setValue(true, forKey: "checked")
            }
            actionSheetController.addAction(action)
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelActionButton)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func addFolderAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Create folder", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "New folder"
            textField.delegate = self
        })
        
        createActionButton = UIAlertAction(title: "Create", style: .default, handler: { (action) in
            let textField = alertController.textFields![0] as UITextField
            
            if let folderName = textField.text, !folderName.isEmpty {
                print("create folder")
            }
        })
        createActionButton!.isEnabled = false
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelActionButton)
        alertController.addAction(createActionButton!)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addNewAction(_ sender: UIButton) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let items = ["New Folder", "Camera Roll", "iCloud Drive"]
        for item in items {
            let action = UIAlertAction(title: item, style: .default, handler: { (action) in
                print(item)
            })
            
            actionSheetController.addAction(action)
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelActionButton)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - Toolbar actions
    
    @IBAction func toolbarAction(_ sender: Any) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let items = ["New Folder", "Camera Roll", "iCloud Drive"]
        for item in items {
            let action = UIAlertAction(title: item, style: .default, handler: { (action) in
                print(item)
            })
            
            actionSheetController.addAction(action)
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelActionButton)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func toolbarCopyAction(_ sender: Any) {
        
    }
    
    @IBAction func toolbarMoveAction(_ sender: Any) {
        
    }
    
    @IBAction func toolbarUnzipAction(_ sender: Any) {
        
    }
    
    @IBAction func toolbarDeleteAction(_ sender: Any) {
        // TODO: delete file or folder
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let createActionButton = createActionButton {
            let lenght = text.count + string.count - range.length
            createActionButton.isEnabled = lenght != 0
        }
        
        return true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FoldersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row + 1)
    }
}
