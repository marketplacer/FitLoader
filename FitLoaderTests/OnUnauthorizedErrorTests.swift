
import UIKit
import XCTest
import Dodo
import MprHttp

class OnUnauthorizedErrorTests: XCTestCase {
  
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
    
    var didCallUnauthorizedWithReponse: NSHTTPURLResponse?
    var didCallUnauthorizedWithText: String?
    
    loader.onUnauthorized = { error, repsonse, text in
      didCallUnauthorizedWithReponse = repsonse
      didCallUnauthorizedWithText = text
    }
    
    var calledOnError = false
    
    loader.onError = { _, _, _ in
      calledOnError = true
      return false
    }
    
    loader.startLoading()
    httpTextMock.simulateError(401, bodyTest: "Unauthorized error")
    
    XCTAssertEqual(401, didCallUnauthorizedWithReponse?.statusCode)
    XCTAssertEqual("Unauthorized error", didCallUnauthorizedWithText)

    XCTAssertFalse(dodoMock.results.visible)
    XCTAssertFalse(calledOnError) // Dot not call onError when onUnauthorized is handled
  }

}
