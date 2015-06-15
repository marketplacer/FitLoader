
/// Emulates different network conditions in unit tests.
class ReachabilityMock: Reachability {
  var currentReachabilityStatusMock = NetworkStatus(ReachableViaWiFi.rawValue)
  
  override func currentReachabilityStatus() -> NetworkStatus {
    return currentReachabilityStatusMock
  }
}