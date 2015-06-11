import Foundation

public struct TegReachabilityConstants {
    public static var errorMessages = TegReachabilityErrorMessages()
}

public struct TegReachabilityErrorMessages {
  public var unexpectedResponse = NSLocalizedString("Unexpected response",
    comment: "A short error message shown when the app loads data from the server buy receives data in unexpected format.")
  
  public var noInternet = NSLocalizedString("No Internet connection",
    comment: "A short error message shown when there is no Internet connection.")
  
  public var unknownNetworkError = NSLocalizedString("Connection error",
    comment: "A short error message shown when an unknown network error occurs and the app can not load data from the server.")
}