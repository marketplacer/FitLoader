import UIKit
import XCTest
import Dodo
import MprHttp

class OnErrorHandlerTests: XCTestCase {
  
  var httpTextMock: TegHttpTextMock!
  var viewControllerMock: ReachableViewControllerMock!
  var dodoMock: DodoMock!
  var reachabilityMock: ReachabilityMock!
  var identity: TegHttpRequestIdentity!
  
  override func setUp() {
    super.setUp()
    
    identity = TegHttpRequestIdentity(url: "http://test.com")
    
    // Mock view controller
    httpTextMock = TegHttpTextMock()
    viewControllerMock = ReachableViewControllerMock()
    
    // Mock Dodo
    dodoMock = DodoMock()
    viewControllerMock.view.dodo = dodoMock
    
    // Mock reachability
    reachabilityMock = ReachabilityMock()
    TegReachability.shared.reachability = reachabilityMock
  }
  
  func testCallOnErrorHandler_errorIsHandledByClosure() {
    let loader = TegReachabilityLoader(httpText: httpTextMock,
      requestIdentity: identity,
      viewController: viewControllerMock,
      authentication: nil,
      onSuccess: { text in true }
    )
    
    var didCallOnErrorWithReponse: NSHTTPURLResponse?
    var didCallOnErrorWithText: String?
    
    loader.onError = { error, repsonse, text in
      didCallOnErrorWithReponse = repsonse
      didCallOnErrorWithText = text
      return true
    }
    
    loader.startLoading()
    httpTextMock.simulateError(500, bodyTest: "Server error")
    
    XCTAssertEqual(500, didCallOnErrorWithReponse?.statusCode)
    XCTAssertEqual("Server error", didCallOnErrorWithText)

    XCTAssertFalse(dodoMock.results.visible)
  }
  
  func testCallOnErrorHandler_errorIsNotHandledByClosure_showError() {
    let loader = TegReachabilityLoader(httpText: httpTextMock,
      requestIdentity: identity,
      viewController: viewControllerMock,
      authentication: nil,
      onSuccess: { text in true }
    )
    
    loader.onError = { error, repsonse, text in
      return false
    }
    
    loader.startLoading()
    httpTextMock.simulateError(500, bodyTest: "Server error")
    
    XCTAssert(dodoMock.results.visible)
  }
}
