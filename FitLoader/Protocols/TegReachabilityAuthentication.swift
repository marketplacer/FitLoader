import Foundation
import MprHttp

public protocol TegReachabilityAuthentication {
  public func httpHeader() -> TegHttpHeader?
}
