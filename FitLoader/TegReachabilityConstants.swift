import Foundation

public struct TegReachabilityConstants {
  public static let errorMessages = TegReachabilityErrorMessages()
  public static let knownErrorMessageKeyName = "knownErrorText"
}

public struct TegReachabilityErrorMessages {
  public let unexpectedResponse = NSLocalizedString("Unexpected response",
    comment: "A short error message shown when the app loads data from the server buy receives data in unexpected format.")
  
  public let noInternet = NSLocalizedString("No Internet connection",
    comment: "A short error message shown when there is no Internet connection.")
  
  public let unknownNetworkError = NSLocalizedString("Connection error",
    comment: "A short error message shown when an unknown network error occurs and the app can not load data from the server.")
}