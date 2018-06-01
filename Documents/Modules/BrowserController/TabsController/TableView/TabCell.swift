import UIKit

protocol TabCellDelegate: class {
    func didPressCloseTab(tab: Tab, cell: TabCell)
}

class TabCell: UITableViewCell {
    
    static let identifier = "TabCell"

    weak var delegate: TabCellDelegate?
    private var tab: Tab?
    
    @IBOutlet private weak var tabLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(tab: Tab) {
        self.tab = tab
        tabLabel?.text = tab.name
    }
    
    @IBAction func dismissController(_ sender: Any) {
        if let tab = tab {
            delegate?.didPressCloseTab(tab: tab, cell: self)
        }
    }
}
