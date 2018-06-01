import UIKit

protocol TabsControllerDelegate: class {
    func didSelectTab(tab: Tab, webViewIndex: Int)
    func didPressAddTab()
    func didCloseTabsController()
}

final class TabsController: UIViewController, StoryboardInstantiable {
    
    static var storyboardName: String = "TabsController"

    @IBOutlet weak var tabsTableView: UITableView!
    
    weak var delegate: TabsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabsTableView.tableFooterView = UIView()
    }
    
    // MARK: - Toolbar actions
    
    @IBAction func closeAllAction(_ sender: Any) {
        Tab.removeAll()
        tabsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    @IBAction func addTabAction(_ sender: Any) {
        addTab()
    }
    
    @IBAction func dismissController(_ sender: Any) {
        dismissAction()
        delegate?.didCloseTabsController()
    }
    
    private func dismissAction() {
        dismiss(animated: false, completion: nil)
    }
    
    func addTab() {
        dismissAction()
        delegate?.didPressAddTab()
    }
}

extension TabsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tabs = Tab.get(),
            !tabs.isEmpty {
            
            return tabs.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tabs = Tab.get(),
            !tabs.isEmpty {
            
            let tab = tabs[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TabCell.identifier) as! TabCell
            cell.setupCell(tab: tab)
            cell.delegate = self
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewTabCell.identifier) as! NewTabCell
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? NewTabCell {
            addTab()
        } else {
            if let tabs = Tab.get(),
                !tabs.isEmpty {
                
                let tab = tabs[indexPath.row]
                delegate?.didSelectTab(tab: tab, webViewIndex: indexPath.row)
                delegate?.didCloseTabsController()
                dismissAction()
            }
        }
    }
}

extension TabsController: NewTabCellDelegate {
    func didPressDismissController(cell: NewTabCell) {
        dismissAction()
        delegate?.didCloseTabsController()
    }
}

extension TabsController: TabCellDelegate {
    func didPressCloseTab(tab: Tab, cell: TabCell) {
        tab.remove()
        
        if let indexPath = tabsTableView.indexPath(for: cell) {
            if let tabs = Tab.get(),
                tabs.isEmpty {

                tabsTableView.reloadSections(IndexSet(integer: 0), with: .fade)
            } else {
                tabsTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
