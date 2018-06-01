import Foundation
import UIKit


extension BrowserController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Bookmarks.get()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.identifier, for: indexPath) as! BookmarkCollectionViewCell
        
        if let bookmarks = Bookmarks.get(),
            !bookmarks.isEmpty {
            
            cell.setupCell(bookmark: bookmarks[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let bookmarks = Bookmarks.get(),
            !bookmarks.isEmpty {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.webViewConteiner.alpha = 1
                collectionView.alpha = 0
            })
            
            let bookMark = bookmarks[indexPath.row]
            
            if canAddTab {
                let webView = UIWebView(frame: webViewConteiner.bounds)
                webView.delegate = self
                
                let url = URL(string: bookMark.url!)!
                var request = URLRequest(url: url)
                request.setValue(UserAgent.selected.value, forHTTPHeaderField: "User-Agent")
                webView.loadRequest(request)
                webViewsArray.append(webView)
                
                if let currentWebView = currentWebView {
                    currentWebView.removeFromSuperview()
                    self.currentWebView = webView
                    webViewConteiner.addSubview(webView)
                }
            }
            
            selectManagedObject(bookMark)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 4
        return CGSize(width: width, height: width)
    }
    
    func setupCollectionViewCell(collectionView: UICollectionView) {
        collectionView.registerReusableCell(BookmarkCollectionViewCell.self)
    }
}
