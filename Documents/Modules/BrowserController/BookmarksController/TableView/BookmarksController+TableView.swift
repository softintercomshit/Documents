import UIKit


extension BookmarksController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return displayType == .bookmarks ? 1 : History.get()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return displayType == .bookmarks ? Bookmarks.get()?.count ?? 0 : History.get()?[section].historyItem?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: displayType.cellIdentifier, for: indexPath)
        
        if let cell = cell as? BookmarkCell {
            if let bookmarks = Bookmarks.get() {
                let bookmark = bookmarks[indexPath.row]
                
                cell.setupCell(bookmark: bookmark)
            }
        } else if let cell = cell as? HistoryCell {
            if let history = History.get(),
                let historyItems = history[indexPath.section].historyItem,
                let historyItem = historyItems[indexPath.row] as? HistoryItem {
                
                cell.setupCell(historyItem: historyItem)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return displayType == .bookmarks ? nil :formatedDate((History.get()?[section].date!)!)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return displayType == .bookmarks ? 0 : UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayType == .bookmarks ? selectBookmark(indexPath) : selectHistoryItem(indexPath: indexPath)
        
        dismissController()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            displayType == .bookmarks ? deleteBookmarkCell(tableView, indexPath) : deleteHistoryCell(tableView, indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if let bookmarks = Bookmarks.get() {
            let fromBookmark = bookmarks[fromIndexPath.row]
            let toBookmark = bookmarks[to.row]
            
            Bookmarks.reorder(source: fromBookmark, destination: toBookmark)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return displayType == .bookmarks
    }
    
    func registerCell(tableView: UITableView) {
        tableView.register(BookmarkCell.self, forCellReuseIdentifier: "BookmarkCell")
        tableView.register(UINib(nibName: "BookmarkCell", bundle: nil), forCellReuseIdentifier: "BookmarkCell")
        
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
    }
    
    private func formatedDate(_ date: NSDate) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        let formatedString = dateformatter.string(from: date as Date)
        
        return formatedString
    }
    
    private func deleteHistoryCell(_ tableView: UITableView, _ indexPath: IndexPath) {
        if let history = History.get(),
            let historyItems = history[indexPath.section].historyItem {
            
            let historyItem = historyItems[indexPath.row] as! HistoryItem
            historyItem.remove()
            
            if (History.get()?.isEmpty)! {
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    private func deleteBookmarkCell(_ tableView: UITableView, _ indexPath: IndexPath) {
        if let bookmarks = Bookmarks.get() {
            let bookmark = bookmarks[indexPath.row]
            bookmark.remove()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func selectBookmark(_ indexPath: IndexPath) {
        if let bookmarks = Bookmarks.get() {
            let bookmark = bookmarks[indexPath.row]
            
            delegate?.didSelectBookmark(bookmark: bookmark)
        }
    }
    
    private func selectHistoryItem(indexPath: IndexPath) {
        if let history = History.get(),
            let historyItems = history[indexPath.section].historyItem {
            
            let historyItem = historyItems[indexPath.row] as! HistoryItem
            delegate?.didSelectHistoryItem(historyItem: historyItem)
        }
    }
}
