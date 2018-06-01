import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookmarkCollectionViewCell"
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(bookmark: Bookmarks) {
        titleLabel.text = bookmark.name
        
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
