
/// Emulates different network conditions in unit tests.
class ReachabilityMock: MprReachability {
  var currentReachabilityStatusMock = MprNetworkStatus(ReachableViaWiFi.rawValue)
  
  override func currentReachabilityStatus() -> MprNetworkStatus {
    return currentReachabilityStatusMock
  }
}