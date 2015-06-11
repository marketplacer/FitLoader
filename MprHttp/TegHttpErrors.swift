//
//  List of custom error codes for HTTP errors.
//

import Foundation

public enum TegHttpError: Int {
  case CouldNotParseUrlString = 1
  
  // There is a response from server, but it is not 200
  case Not200FromServer = 2
  
  case FailedToConvertResponseToText = 3
  
  // Response is received and is 200 but the iOS app can not accept it for some other reasons,
  // like a parsing error.
  case UnexpectedResponse = 4

  public var nsError: NSError {
    let domain = NSBundle.mainBundle().bundleIdentifier ?? "teg.unknown.domain"
    return NSError(domain: domain, code: rawValue, userInfo: nil)
  }
}
