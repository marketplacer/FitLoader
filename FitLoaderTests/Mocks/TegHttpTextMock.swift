//
//  This class emulates an HTTP request.
//  It is used in unit tests instead of TegHttp to verify client-server communication
//  without sending real HTTP requests over the network.
//

import Foundation
import MprHttp

class TegHttpTextMock: TegHttpText {
  
  private var onSuccess: ((String)->())?
  private var onError: ((NSError?, NSHTTPURLResponse?, String?)->())?
  private var onAlways: (()->())?

  var identity = TegHttpRequestIdentity(url: "unused")
  
  var url: String { return identity.url }
  var httpMethod: TegHttpMethod { return identity.method }
  var httpHeaders: [TegHttpHeader] { return identity.httpHeaders }
  
  var bodyText: String? {
    if let requestBody = identity.requestBody {
      return NSString(data: requestBody, encoding: NSUTF8StringEncoding) as? String
    }
    
    return nil
  }
  
  override func load(identity: TegHttpRequestIdentity,
    onSuccess: (String)->(),
    onError: ((NSError?, NSHTTPURLResponse?, String?)->())? = nil,
    onAlways: (()->())? = nil) -> NSURLSessionDataTask? {
      
    self.identity = identity
      
    self.onSuccess = onSuccess
    self.onError = onError
    self.onAlways = onAlways
      
    log()
      
    return TegMockedNSUrlSessionDataTask()
  }
  
  func simulateSuccessfulResponse(bodyText bodyText: String) {
    onAlways?()
    
    onSuccess?(bodyText)
  }
  
  func simulateError_unprocessableEntity422(bodyText: String?) {
    onAlways?()
    
    let response = NSHTTPURLResponse(URL: identity.nsUrl!,
      statusCode: 422,
      HTTPVersion: nil,
      headerFields: nil)
    
    onError?(nil, response, bodyText)
  }
  
  func simulateError(httpStatusCode: Int, bodyTest: String?, error: NSError? = nil) {
    onAlways?()
    
    let response = NSHTTPURLResponse(URL: identity.nsUrl!,
      statusCode: httpStatusCode,
      HTTPVersion: nil,
      headerFields: nil)
    
    onError?(error, response, bodyTest)
  }

  func simulateError_unauthorized401() {
    onAlways?()
    
    let response = NSHTTPURLResponse(URL: identity.nsUrl!,
      statusCode: 401,
      HTTPVersion: nil,
      headerFields: nil)
    
    onError?(nil, response, nil)
  }
  
  private func log() {
    print("HTTP \(httpMethod.rawValue) MOCKED \(url)")
  }
}
