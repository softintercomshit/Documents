import Foundation


struct UserAgent {
    let name: String
    var value: String
}

extension UserAgent {
    static var agents: [UserAgent] {
        return [UserAgent(name: "Default", value: ""),
                UserAgent(name: "Phone", value: "Mozilla/5.0 (Mobile; rv:26.0) Gecko/26.0 Firefox/26.0"),
                UserAgent(name: "Pad", value: "Mozilla/5.0 (Tablet; rv:26.0) Gecko/26.0 Firefox/26.0"),
                UserAgent(name: "Desktop", value: "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)"),
                UserAgent.custom]
    }
    
    static var selected: UserAgent {
        let defaults = UserDefaults.standard
        if let savedUserAgent = defaults.object(forKey: "saveduseragent") as? [String: String],
            let name = savedUserAgent["name"],
            let value = savedUserAgent["value"] {
            
            let userAgent = UserAgent(name: name, value: value)
            
            return userAgent
        }
        
        return UserAgent(name: "Default", value: "")
    }
    
    static var custom: UserAgent {
        let defaults = UserDefaults.standard
        if let customUserAgent = defaults.object(forKey: "customuseragent") as? [String: String],
            let name = customUserAgent["name"],
            let value = customUserAgent["value"] {
            
            let userAgent = UserAgent(name: name, value: value)
            
            return userAgent
        }
        
        return UserAgent(name: "Custom", value: "")
    }
    
    static func saveCustom(userAgent: UserAgent) {
        let defaults = UserDefaults.standard
        let dict = ["name": userAgent.name, "value": userAgent.value]
        defaults.set(dict, forKey: "customuseragent")
        defaults.synchronize()
    }
    
    func save() {
        let defaults = UserDefaults.standard
        let dict = ["name": self.name, "value": self.value]
        defaults.set(dict, forKey: "saveduseragent")
        defaults.synchronize()
    }
}
