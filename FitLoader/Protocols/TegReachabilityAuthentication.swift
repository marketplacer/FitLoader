import Foundation
import MprHttp

public protocol TegReachabilityAuthentication {
  func httpHeader() -> TegHttpHeader?
}
