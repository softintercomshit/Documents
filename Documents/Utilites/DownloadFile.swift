import Alamofire


public struct DownloadFile {
    public static func url(_ url: URL, completionHandler: ((_ progress: Float, _ path: URL?) -> ())?) {
        guard Alamofire.NetworkReachabilityManager(host: "www.apple.com")?.isReachable == true else {
            Alert.show(title: "Error", message: "Please check yor internet conection.")
            return
        }
        
        let destination = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(url.absoluteString, to: destination).response{ response in
            DispatchQueue.main.async {
                completionHandler?(1.0, response.destinationURL)
            }
            
            }.downloadProgress { (progress) in
                DispatchQueue.main.async {
                    let progress = Float(progress.completedUnitCount) / Float(progress.totalUnitCount)
                    if progress != 1.0 {
                        completionHandler?(progress, nil)
                    }
                }
        }
    }
    
    private init(){}
}

