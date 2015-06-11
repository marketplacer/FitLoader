import Foundation
import MprHttp

protocol TegReachabilityAuthentication {
  func httpHeader() -> TegHttpHeader?
}
