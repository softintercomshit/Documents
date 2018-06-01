import UIKit
import WebKit
import AVKit
import CoreData


final class BrowserController: UIViewController, StoryboardInstantiable {
    
    static var storyboardName: String = BrowserController.identifier
    
    // MARK: - Outlets
    
    @IBOutlet var webViewConteiner: UIView! {
        didSet {
            setupTabs()
        }
    }
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.autocapitalizationType = .none
            searchBar.setImage(#imageLiteral(resourceName: "NavigationBarReload"), for: .resultsList, state: .normal)
        }
    }
    @IBOutlet private weak var backButtonItem: UIBarButtonItem!
    @IBOutlet private weak var forwardButtonItem: UIBarButtonItem!
    @IBOutlet private weak var actionButtonItem: UIBarButtonItem!
    @IBOutlet private weak var bookmarksButtonItem: UIBarButtonItem!
    @IBOutlet private weak var bookmarksCollectionView: UICollectionView!
    
    // MARK: - Global vars
    
    private var urlToDownload: URL?
    var currentWebView: UIWebView?
    private var currenttab: Tab?
    var webViewsArray = [UIWebView]()
    var canAddTab = false
    
    // Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewCell(collectionView: bookmarksCollectionView)
        registerNotification()
        
        setDoneOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let webView = currentWebView {
            webView.frame = webViewConteiner.bounds
        }
    }
    
    // MARK: - NSNotification
    private func registerNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemBecameCurrent(notification:)),
                                               name: NSNotification.Name("AVPlayerItemBecameCurrentNotification"),
                                               object: nil)
    }
    
    // MARK: - Buttons actions
    
    @IBAction private func goBack(_ sender: Any) {
        if let webView = currentWebView,
            webView.canGoBack {
            
            webView.goBack()
        }
    }
    
    @IBAction private func goForward(_ sender: Any) {
        if let webView = currentWebView,
            webView.canGoForward {
            
            webView.goForward()
        }
    }
    
    @IBAction private func bookMarks(_ sender: Any) {
        let bookmarksController = BookmarksController.instantiate()
        bookmarksController.delegate = self
        let navigationController = UINavigationController(rootViewController: bookmarksController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction private func action(_ sender: UIButton) {
        if let webView = currentWebView,
            let request = webView.request,
            let url = request.url {
            
            let bookmarkAction = BookmarkActivity(name: webView.title, strUrl: url.absoluteString, iconUrl: webView.iconUrl)
            
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: [bookmarkAction, DownloadActivity()])
            activityViewController.popoverPresentationController?.sourceView = sender
            
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func tabsAction(_ sender: UIBarButtonItem) {
        let tabsController = TabsController.instantiate()
        tabsController.delegate = self
        let navigationController = UINavigationController(rootViewController: tabsController)
        navigationController.modalPresentationStyle = .popover
        
        let popover = navigationController.popoverPresentationController
        popover?.sourceView = view
//        popover?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        present(navigationController, animated: false, completion: nil)
    }
    
    // MARK: - observers actions
    
    @objc private func playerItemBecameCurrent(notification: Notification) {
        if let avPlayerItem = notification.object as? AVPlayerItem,
            let asset = avPlayerItem.asset as? AVURLAsset {
            
            self.urlToDownload = asset.url
        }
    }
    
    @objc private func prepareDownload() {
        if let url = urlToDownload {
            if url.pathExtension == "m3u8" {
                if url.absoluteString.contains("vimeo.") {
                    Vimeo.check(url: url, completionHandler: { [weak self] (url) in
                        self?.showAlert(url: url)
                    })
                }
            } else {
                showAlert(url: url)
            }
        }
    }
    
    private func showAlert(url: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            Alert.show(title: "Download file?", message: url.lastPathComponent, actionNames: "Cancel", "OK", actionHandler: { [weak self] buttonIndex in
                if buttonIndex == 1 {
                    self?.downloadFile(url: url)
                }
            })
        })
    }
    
    private func downloadFile(url: URL) {
        DownloadFile.url(url, completionHandler: { [weak self] (progress, path) in
            self?.urlToDownload = nil
            if let path = path {
                print(path)
                print(url)
            }
            print(progress)
        })
    }
    
    fileprivate func navigateToAddress(text: String?) {
        func engineSearch(text: String) {
            let text = text.replacingOccurrences(of: " ", with: "+")
            let url = URL(string: "\(SearchEngine.selected.searchUrl)\(text)")!
            var request = URLRequest(url: url)
            request.setValue(UserAgent.selected.value, forHTTPHeaderField: "User-Agent")
            if let webView = currentWebView {
                webView.loadRequest(request)
            }
        }
        
        if let text = text, !text.isEmpty {
            
            if canAddTab {
                let webView = UIWebView(frame: webViewConteiner.bounds)
                webView.delegate = self
                webViewsArray.append(webView)
                
                if let currentWebView = currentWebView {
                    currentWebView.removeFromSuperview()
                    self.currentWebView = webView
                    webViewConteiner.addSubview(webView)
                }
            }
            
            if var url = URL(string: text) {
                if urlIsValid(url: url) {
                    if url.scheme == nil {
                        url = URL(string: "http://\(url.absoluteString)")!
                    }
                    var request = URLRequest(url: url)
                    request.setValue(UserAgent.selected.value, forHTTPHeaderField: "User-Agent")
                    if let webView = currentWebView {
                        webView.loadRequest(request)
                    }
                } else {
                    engineSearch(text: text)
                }
            } else {
                engineSearch(text: text)
            }
        }
    }
    
    private func urlIsValid(url: URL) -> Bool {
        let urlRegEx = "((?:http|https):\\/\\/)?[\\w\\d\\-_]+\\.\\w+(\\.\\w{2,})?(\\/(?<=\\/)(?:[\\w\\d\\-.\\/_\\?\\=]+)?)?"
        
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: url.absoluteString)
    }
    
    func selectManagedObject<T: NSManagedObject>(_ object: T) {
        if let strUrl = object.value(forKey: "url") as? String,
            let name = object.value(forKey: "name") as? String {
            
            let url = URL(string: strUrl)!
            var request = URLRequest(url: url)
            request.setValue(UserAgent.selected.value, forHTTPHeaderField: "User-Agent")
            if let webView = currentWebView {
                webView.loadRequest(request)
            }
            
            searchBar.text = "\(name) - \(url.absoluteString)"
        }
    }
    
    private func setupTabs() {
        if let tabs = Tab.get(),
            !tabs.isEmpty {
            
            for _ in tabs {
                let webView = UIWebView()
                webViewsArray.append(webView)
            }
            
            currentWebView = webViewsArray[0]
            currentWebView?.delegate = self
            
            let url = URL(string: tabs.first!.url!)!
            var request = URLRequest(url: url)
            request.setValue(UserAgent.selected.value, forHTTPHeaderField: "User-Agent")
            currentWebView?.loadRequest(request)
            
            webViewConteiner.addSubview(currentWebView!)
            UIView.animate(withDuration: 0.25, animations: {
                self.webViewConteiner.alpha = 1
                self.bookmarksCollectionView.alpha = 0
            })
        } else {
            currentWebView = UIWebView()
            webViewConteiner.addSubview(currentWebView!)
            currentWebView?.delegate = self
        }
    }
    
    private func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        searchBar.inputAccessoryView = keyboardToolbar
    }
    
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}


// MARK: - UISearchBarDelegate
extension BrowserController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigateToAddress(text: searchBar.text)
        
        if webViewConteiner.alpha == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.bookmarksCollectionView.alpha = 0
                self.webViewConteiner.alpha = 1
            })
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if let webView = currentWebView,
            let request = webView.request,
            let url = request.url {
            
            searchBar.text = url.absoluteString
        }
        
        return true
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        currentWebView?.reload()
    }
}

extension BrowserController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let request = webView.request,
            let url = request.url {
            
            if canAddTab {
                Tab.add(name: webView.title, strUrl: webView.request?.url?.absoluteString ?? "", iconUrl: webView.iconUrl)
                canAddTab = false
            }
            
            if let tab = currenttab {
                tab.update(name: webView.title, strUrl: webView.request?.url?.absoluteString ?? "", iconUrl: webView.iconUrl)
            }
            
            History.add(name: webView.title, strUrl: url.absoluteString, iconUrl: webView.iconUrl)
            searchBar.text = "\(webView.title ?? "") - \(url.absoluteString)"
            
            webView.scrollView.delegate = self
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.backButtonItem.isEnabled = webView.canGoBack
        self.forwardButtonItem.isEnabled = webView.canGoForward
        
//        let fileExtension = request.url!.pathExtension
//        print("---------> \(fileExtension)")
//        if ["pdf", "mp3", "mp4"].contains(fileExtension) {
//            print(request.url ?? "nil")
//        }

//        FileTypeDetector.findFileType(fromURL: request.url?.absoluteString) { (name, type) in
//            print(name, type)
//        }
        
        return true
    }
}

extension BrowserController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar?.resignFirstResponder()
    }
}

extension BrowserController: BookmarksControllerDelegate {
    func didSelectBookmark(bookmark: Bookmarks) {
        selectManagedObject(bookmark)
    }
    
    func didSelectHistoryItem(historyItem: HistoryItem) {
        selectManagedObject(historyItem)
    }
}

extension BrowserController: TabsControllerDelegate {
    func didSelectTab(tab: Tab, webViewIndex: Int) {
        currenttab = tab
        
        UIView.animate(withDuration: 0.25) {
            self.webViewConteiner.alpha = 1
            self.bookmarksCollectionView.alpha = 0
        }
        
        currentWebView?.removeFromSuperview()
        
        currentWebView = webViewsArray[webViewIndex]
        currentWebView?.delegate = self
        
        if currentWebView?.request == nil {
            let url = URL(string: tab.url!)!
            var request = URLRequest(url: url)
            request.setValue(UserAgent.selected.value, forHTTPHeaderField: "User-Agent")
            currentWebView?.loadRequest(request)
        }
        
        currentWebView!.frame = webViewConteiner.bounds
        webViewConteiner.addSubview(currentWebView!)
        
        if let name = tab.name,
            let url = tab.url {
            
            searchBar.text = "\(name) - \(url)"
        }
    }
    
    func didPressAddTab() {
        enableToolBarItems(false)
        canAddTab = true
        
        UIView.animate(withDuration: 0.25) {
            self.webViewConteiner.alpha = 0
            self.bookmarksCollectionView.alpha = 1
        }
    }
    
    func didCloseTabsController() {
        enableToolBarItems(true)
    }
    
    private func enableToolBarItems(_ enable: Bool) {
        if enable {
            if let webView = currentWebView {
                backButtonItem.isEnabled = webView.canGoBack
                forwardButtonItem.isEnabled = webView.canGoForward
            }
        } else {
            backButtonItem.isEnabled = enable
            forwardButtonItem.isEnabled = enable
        }

        actionButtonItem.isEnabled = enable
        bookmarksButtonItem.isEnabled = enable
    }
}
