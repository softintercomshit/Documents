import Foundation


struct SearchEngine {
    let name: String
    let searchUrl: String
}

extension SearchEngine {
    static var engines: [SearchEngine] {
        return [SearchEngine(name: "Google", searchUrl: "https://www.google.com/search?q="),
                SearchEngine(name: "Bing", searchUrl: "https://www.bing.com/search?q="),
                SearchEngine(name: "Yahoo", searchUrl: "https://search.yahoo.com/search?p="),
                SearchEngine(name: "Yandex", searchUrl: "https://www.yandex.com/search/?text="),
                SearchEngine(name: "Baidu", searchUrl: "http://www.baidu.com/s?wd="),
                SearchEngine(name: "DuckDuckGo", searchUrl: "https://duckduckgo.com/?q=")]
    }
    
    static var selected: SearchEngine {
        let defaults = UserDefaults.standard
        if let savedSearchEngine = defaults.object(forKey: "savedsearchengine") as? [String: String],
            let name = savedSearchEngine["name"],
            let searchUrl = savedSearchEngine["searchUrl"] {
            
            let searchEngine = SearchEngine(name: name, searchUrl: searchUrl)
            
            return searchEngine
        }
        
        return SearchEngine(name: "Google", searchUrl: "https://www.google.com/search?q=")
    }
    
    func save() {
        let defaults = UserDefaults.standard
        let dict = ["name": self.name, "searchUrl": self.searchUrl]
        defaults.set(dict, forKey: "savedsearchengine")
        defaults.synchronize()
    }
}
