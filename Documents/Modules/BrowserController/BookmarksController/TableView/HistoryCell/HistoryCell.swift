import Foundation
import UIKit
import AlamofireImage


final class HistoryCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
//    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        
    }
    
    func setupCell(historyItem: HistoryItem) {
        nameLabel.text = historyItem.name
        urlLabel.text = historyItem.url
        
//        if let strUrl = historyItem.iconUrl,
//            let url = URL(string: strUrl) {
//
//            iconImageView?.af_setImage(
//                withURL: url,
//                placeholderImage: nil,
//                imageTransition: .crossDissolve(0.5)
//            )
//        }
    }
}
