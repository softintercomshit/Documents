import UIKit

protocol NewTabCellDelegate: class {
    func didPressDismissController(cell: NewTabCell)
}

class NewTabCell: UITableViewCell {
    
    static let identifier = "NewTabCell"
    
    weak var delegate: NewTabCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func dismissController(_ sender: Any) {
        delegate?.didPressDismissController(cell: self)
    }
}
