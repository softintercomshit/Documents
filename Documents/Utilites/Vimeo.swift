import Foundation
import Alamofire


struct Vimeo {
    static func check(url: URL, completionHandler: ((_ vimeoURL: URL) -> Void)?) {
        if let firstHalfOfUrl = url.absoluteString.components(separatedBy: "/video/").first,
            let url = URL(string: firstHalfOfUrl) {
            
            let id = url.lastPathComponent
            
            if let url = URL(string: "https://player.vimeo.com/video/" + id + "/config") {
                Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (data) in
                    if let dict = data.value as? [String: Any], let request = dict["request"] as? [String: Any], let files = request["files"] as? [String: Any], let progressive = files["progressive"] as? [[String: Any]] {
                        let sortedArray = progressive.sorted(by: {($0["height"] as? NSNumber)?.intValue ?? 0 > ($1["height"] as? NSNumber)?.intValue ?? 0})
                        if let strUrl = sortedArray[0]["url"] as? String {
                            if let url = URL(string: strUrl) {
                                completionHandler?(url)
                            }
                        }
                    }
                })
            }
        }
    }
}
