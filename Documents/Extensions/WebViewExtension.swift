import UIKit


extension UIWebView {
    var title: String? {
        let title = stringByEvaluatingJavaScript(from: "document.title")
        
        return title
    }
    
    var iconUrl: String? {
        let rels = ["apple-touch-icon",
                    "apple-touch-icon-precomposed",
                    "icon",
                    "shortcut icon"]
        
        for rel in rels {
            if let iconUrl = stringByEvaluatingJavaScript(from: "document.querySelector(\"link[rel='\(rel)']\").href"),
                !iconUrl.isEmpty {
                
                return iconUrl
            }
        }
        
        return nil
    }
}
