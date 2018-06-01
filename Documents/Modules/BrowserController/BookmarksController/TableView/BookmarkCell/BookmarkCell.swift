import Foundation
import UIKit
import AlamofireImage


final class BookmarkCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        
    }
    
    func setupCell(bookmark: Bookmarks) {
         nameLabel?.text = bookmark.name
        
        if let strUrl = bookmark.iconUrl,
            let url = URL(string: strUrl) {
            
            iconImageView?.af_setImage(
                withURL: url,
                placeholderImage: nil,
                imageTransition: .crossDissolve(0.5)
            )
        }
    }
}
