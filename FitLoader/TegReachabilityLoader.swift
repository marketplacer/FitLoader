import UIKit
import MprHttp

/**

Loading Http text from server.

If onSuccess callback returns false - the request is considered failed.
Return false when the returned text from server is not valid.

*/
@objc public class TegReachabilityLoader: NSObject {
  private let requestIdentity: TegHttpRequestIdentity
  private let httpText: TegHttpText
  
  // Used for adding a HTTP header with authentication information.
  // Rather than storing this header in an instance variable we call a function to get it.
  // The function then can load this data from the keychain.
  // This approach is more secure because it avoids keeping this sensitive information in memory.
  private let authentication: TegReachabilityAuthentication?
  
  private var downloadTask: NSURLSessionDataTask?
  
  private var onSuccess: ((String)->(Bool))?
  
  /**
  
  Custom error handler.
  If it returns true it means the error is handled and no error messages are shown.
  If it returns false - it shows the normal error messages.
  
  */
  public var onError: ((NSError?, NSHTTPURLResponse?, String?)->(Bool))?
  
  /**
  
  The handler is called for responses with HTTP status code 401.
  If you supply a closure it will not call onError handler and will not show the error message.
  
  */
  public var onUnauthorized: ((NSError?, NSHTTPURLResponse?, String?)->())?
  
  /// The top view of the view controller will contain an error message view
  public weak var reachableViewController: TegReachableViewController?
  
  /// If present - called before loading is started. Useful to show 'loading' progress indicator.
  public var onStarted: (()->())?
  
  /// If present - called before loading has finished. Useful to hide 'loading' progress indicator.
  public var onFinishedWithSuccessOrError: (()->())?
  
  public init(httpText: TegHttpText,
    requestIdentity: TegHttpRequestIdentity,
    viewController: TegReachableViewController,
    authentication: TegReachabilityAuthentication?,
    onSuccess: (String)->(Bool)) {
      
      self.httpText = httpText
      self.requestIdentity = requestIdentity
      self.onSuccess = onSuccess
      reachableViewController = viewController
      self.authentication = authentication
  }
  
  deinit {
    cancel()
  }
  
  /// Returns true if we are currently loading data from the network.
  public var loading: Bool {
    return downloadTask != nil
  }
  
  public func startLoading() {
    if loading { return }
    if onSuccess == nil { return } // nobody wants the result
    
    TegReachability.shared.hidePreviousFailureMessage()
    
    onStarted?()
    
    var httpHeaders = [TegHttpHeader]()
    
    if let authenticationHttpHeader = authentication?.httpHeader() {
      httpHeaders.append(authenticationHttpHeader)
    }
    
    // Request data is not kept in an instance variable intentionally for security reasons.
    // This prevents keeping sensitive authentication information in memory for long time period.
    let requestIdentityWithAuhenticationHeaders = TegHttpRequestIdentity(
      identityToCopy: requestIdentity, httpHeaders: httpHeaders)
    
    downloadTask = httpText.load(requestIdentityWithAuhenticationHeaders,
      onSuccess: { [weak self] text in
        if self?.handleSucess(text) == false {
          self?.handleError(TegHttpError.UnexpectedResponse.nsError, response: nil, bodyText: text)
        }
      },
      onError: { [weak self] (error, response, body) in
        self?.handleError(error, response: response, bodyText: body)
      },
      onAlways: { [weak self] in
        self?.downloadTask = nil
        self?.onFinishedWithSuccessOrError?()
      }
    )
  }
  
  private func handleSucess(text: String) -> Bool {
    if let currentOnSuccess = onSuccess {
      let result = currentOnSuccess(text)
      
      if result {
        onSuccess = nil // Request is successfull - no need for the callback in the future
      }
      
      return result
    }
    
    return true
  }
  
  private func handleError(error: NSError?, response: NSHTTPURLResponse?, bodyText: String?) {
    if let response = response, onUnauthorized = onUnauthorized where response.statusCode == 401 {
      onUnauthorized(error, response, bodyText)
      // Error is handled by the callback so we are not calling onError and not showing error message.
      return
    }
    
    if let onError = onError {
      if onError(error, response, bodyText) {
        // Error is handled by the callback
        return
      }
    }
    
    // Save this loader as failed loader so the request can be repeated.
    if let reachableViewController = reachableViewController {
      reachableViewController.failedLoader = self
    }
    
    if showKnownErrorMessage(response, bodyText: bodyText) { return }
    
    showUnknownErrorMessage(error)
  }
  
  /**

  Shown the known error message.
  Known error is an error response with HTTP status 422 and a specific body in JSON format
  
  - returns: true if known error is handled
  
  */
  private func showKnownErrorMessage(response: NSHTTPURLResponse?, bodyText: String?) -> Bool {
    if let response = response,
      bodyText = bodyText,
      reachableViewController = reachableViewController,
      knownErrorMessage = TegReachabilityKnownErrorMessage.parse(bodyText, response: response) {
        
      TegReachability.shared.showError422(reachableViewController, bodyText: knownErrorMessage)
      return true
    }
    
    return false
  }
  
  /**
  
  Shows error message for unknown type of network error.
  
  */
  private func showUnknownErrorMessage(error: NSError?) {
    if let reachableViewController = reachableViewController {
      var errorMessage = TegReachabilityConstants.errorMessages.unknownNetworkError
      
      if error?.code == TegHttpError.UnexpectedResponse.rawValue {
        errorMessage = TegReachabilityConstants.errorMessages.unexpectedResponse
      }
      
      TegReachability.shared.showError(reachableViewController, errorMessage: errorMessage)
    }
  }
  
  public func cancel() {
    downloadTask?.cancel()
    downloadTask = nil
  }
}
