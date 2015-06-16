import UIKit
import XCTest
import Dodo
import MprHttp

class TegReachabilityKnownErrorMessageTests: XCTestCase {
  func testKnownErrorMessage() {
    let response =  NSHTTPURLResponse(URL: NSURL(),
      statusCode: 422, HTTPVersion: nil, headerFields: nil)!
    
    let bodyText = "{ \"knownErrorText\": \"🐟\" }"
    let result = TegReachabilityKnownErrorMessage.parse(bodyText, response: response)
    
    XCTAssertEqual("🐟", result!)
  }
  
  func testKnownErrorMessage_responseIsNot422() {
    let response =  NSHTTPURLResponse(URL: NSURL(),
      statusCode: 200, HTTPVersion: nil, headerFields: nil)!
    
    let bodyText = "{ \"knownErrorText\": \"🐟\" }"
    let result = TegReachabilityKnownErrorMessage.parse(bodyText, response: response)
    
    XCTAssert(result == nil)
  }
  
  func testResponseIsNotJson() {
    let response =  NSHTTPURLResponse(URL: NSURL(),
      statusCode: 422, HTTPVersion: nil, headerFields: nil)!
    
    let bodyText = "Not json"
    let result = TegReachabilityKnownErrorMessage.parse(bodyText, response: response)
    
    XCTAssert(result == nil)
  }
  
  func testResponseIsEmpty() {
    let response =  NSHTTPURLResponse(URL: NSURL(),
      statusCode: 422, HTTPVersion: nil, headerFields: nil)!
    
    let bodyText = ""
    let result = TegReachabilityKnownErrorMessage.parse(bodyText, response: response)
    
    XCTAssert(result == nil)
  }
  
  func testResponseIsJsonWithMissingKey() {
    let response =  NSHTTPURLResponse(URL: NSURL(),
      statusCode: 422, HTTPVersion: nil, headerFields: nil)!
    
    let bodyText = "{ \"incorrect\": \"🐟\" }"
    let result = TegReachabilityKnownErrorMessage.parse(bodyText, response: response)
    
    XCTAssert(result == nil)
  }
  
  func testResponseIsJsonWithWrongValueType() {
    let response =  NSHTTPURLResponse(URL: NSURL(),
      statusCode: 422, HTTPVersion: nil, headerFields: nil)!
    
    let bodyText = "{ \"knownErrorText\": 123 }"
    let result = TegReachabilityKnownErrorMessage.parse(bodyText, response: response)
    
    XCTAssert(result == nil)
  }
}
