//
//  Sends an HTTP request and handles reponse.
//
//  Note: callbacks are called asynchronously and NOT in the main queue.
//

import Foundation

class TegDownloaderAsync {
  class func load(requestIdentity: TegHttpRequestIdentity,
    onSuccess: (NSData, NSHTTPURLResponse)->(),
    onError: ((NSError, NSHTTPURLResponse?)->())? = nil,
    onAlways: (()->())? = nil) -> NSURLSessionDataTask? {
      
    if let nsUrl = requestIdentity.nsUrl {
      
      TegDownloaderAsync.logRequest(requestIdentity)
      
      return load(nsUrl,
        requestIdentity: requestIdentity,
        onSuccess: onSuccess,
        onError: onError,
        onAlways: onAlways
      )
    } else {
      if let alwaysHandler = onAlways {
        alwaysHandler()
      }
      
      processError(TegHttpError.CouldNotParseUrlString.nsError, httpResponse: nil, onError: onError)
    }
    
    return nil
  }
  
  private class func load(nsUrl: NSURL,
    requestIdentity: TegHttpRequestIdentity,
    onSuccess: (NSData, NSHTTPURLResponse)->(),
    onError: ((NSError, NSHTTPURLResponse?)->())? = nil,
    onAlways: (()->())? = nil) -> NSURLSessionDataTask? {

    if let mockedResponse = requestIdentity.mockedResponse {
      return respondWithMockedData(mockedResponse, nsUrl: nsUrl,
        requestIdentity: requestIdentity, onSuccess: onSuccess)
    }

    let urlRequest = NSMutableURLRequest(URL: nsUrl)
    urlRequest.HTTPMethod = requestIdentity.method.rawValue
    urlRequest.HTTPBody = requestIdentity.requestBody
      
    if requestIdentity.contentType != TegHttpContentType.Unspecified {
      urlRequest.addValue(requestIdentity.contentType.rawValue, forHTTPHeaderField: "Content-Type")
    }

    for httpHeader in requestIdentity.httpHeaders {
      urlRequest.addValue(httpHeader.value, forHTTPHeaderField: httpHeader.field)
    }
      
    var task = TegDownloaderSession.session.dataTaskWithRequest(urlRequest) {
      (data, response, error) in
      
      if let httpResponse = response as? NSHTTPURLResponse {
        if error == nil {
          onSuccess(data, httpResponse)
        } else {
          self.processError(error, httpResponse: httpResponse, onError: onError)
        }
      } else {
        self.processError(error, httpResponse: nil, onError: onError)
      }
      
      if let alwaysHandler = onAlways {
        alwaysHandler()
      }
    }
      
    task.resume()
    return task
  }
  
  private class func processError(error: NSError, httpResponse: NSHTTPURLResponse?,
    onError: ((NSError, NSHTTPURLResponse?)->())? = nil) {
    
    println("HTTP Error: \(error.description)")
    onError?(error, httpResponse)
  }

  private class func respondWithMockedData(
    mockedResponse: String,
    nsUrl: NSURL,
    requestIdentity: TegHttpRequestIdentity,
    onSuccess: (NSData, NSHTTPURLResponse)->()) -> NSURLSessionDataTask {

    let data = mockedResponse.dataUsingEncoding(NSUTF8StringEncoding)!
    let httpUrlResponse = NSHTTPURLResponse(URL: nsUrl, statusCode: 200,
      HTTPVersion: nil, headerFields: nil)!

    TegQ.runAfterDelay(0.3) { onSuccess(data, httpUrlResponse) }
    return TegMockedNSUrlSessionDataTask()
  }

  // MARK: - Log
  // ---------------
  
  private class func logRequest(requestIdentity: TegHttpRequestIdentity) {
    let mocked = requestIdentity.mockedResponse == nil ? "" : "Mocked "
    println("HTTP \(mocked)\(requestIdentity.method.rawValue) \(requestIdentity.url)")

    if let requestBody = requestIdentity.requestBody {
      if requestBody.length < 1024 * 10 {
        if var currentString = NSString(data: requestBody, encoding: NSUTF8StringEncoding) as? String {
          currentString = TegHttpSensitiveText.hideSensitiveContent(currentString)
          println("----- Request body ------\n\(currentString)\n-----")
        }
      }
    }
  }
}