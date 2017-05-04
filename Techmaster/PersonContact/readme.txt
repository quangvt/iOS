I. NSURLSession
- NSURLSession
+ init(configuration configuration: NSURLSessionConfiguration)
+ init(configuration configuration: NSURLSessionConfiguration, delegate delegate: NSURLSessionDelegate?, delegateQueue queue: NSOperationQueue?)
+ class func sharedSession() -> a href="" NSURLSession

- NSURLSessionConfiguration
+ class func defaultSessionConfiguration() -> NSURLSessionConfiguration
+ class func ephemeralSessionConfiguration() -> NSURLSessionConfiguration
+ class func backgroundSessionConfigurationWithIdentifier(_ identifier: String) -> NSURLSessionConfiguration

- NSURLSessionTask
+ func cancel()
+ func resume()
+ func suspend()
+ NSURLSessionDataTask ____NSURLSessionUploadTask
+ NSURLSessionDownloadTask 
