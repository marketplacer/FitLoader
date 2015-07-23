//
//  Get information about current network status.
//  It is used to show 'no internet connection' message in view controllers.
//

import UIKit

public class TegReachability: NSObject, TegReachabilityMessageDelegate {
  public static let shared = TegReachability()

  var reachability: MprReachability?

  private let message = TegReachabilityMessage()

  private weak var failedReachableViewController: TegReachableViewController?

  private var failedLoader: TegReachabilityLoader? {
    return failedReachableViewController?.failedLoader
  }

  public var listeningForNetworkStatusChanges: Bool {
    return reachability != nil
  }

  override public init() {
    super.init()

    message.delegate = self
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  private var hasInternetConnection: Bool {
    if let reachability = reachability {
      let status = reachability.currentReachabilityStatus()
      return status.rawValue != NotReachable.rawValue
    }

    return false
  }

  public func startListeningForNetworkStatusChanges(hostName: String) {
    if listeningForNetworkStatusChanges { return } // already setup

    let newReachability = MprReachability(hostName: hostName)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: kMprReachabilityChangedNotification, object: newReachability)

    newReachability.startNotifier()
    reachability = newReachability
  }

  public func stopListeningForNetworkStatusChanges(hostName: String) {
    if !listeningForNetworkStatusChanges { return } // not listening

    NSNotificationCenter.defaultCenter().removeObserver(self, name: kMprReachabilityChangedNotification, object: reachability)

    reachability.map { $0.stopNotifier() }
    reachability = nil
  }

  func reachabilityChanged(notification: NSNotification) {
     dispatch_async(dispatch_get_main_queue()) { [weak self] in
      self?.reloadFailedRequestAndUpdateStatusMessage()
    }
  }

  /// Reloads failed request from a reachable view controller, if any.
  public func reloadOldFailedRequest(viewController: UIViewController) {
    if let reachableViewController = viewController as? TegReachableViewController {
      failedReachableViewController = reachableViewController
      reloadFailedRequestAndUpdateStatusMessage()
    }
  }

  private func reloadFailedRequestAndUpdateStatusMessage() {
    if failedLoader != nil { // there is a pending failed request waiting to be reloaded
      reloadFailedConnection()
    } else {
      hidePreviousFailureMessage()
    }
  }
  
  ///  Shows the given error message. If there is no Internet connection - shows "No Internet" message instead.
  private func showErrorOrReportNoInternet(errorMessage: String) {
    if !hasInternetConnection {
      showNoInternetMessage()
      return
    }

    if let viewController = failedReachableViewController {
      message.showWithReloadButton(errorMessage, inViewController: viewController)
    }
  }

  // Shows unexpected error comming from the server.
  func showError(failedReachableViewController: TegReachableViewController, errorMessage: String) {
    self.failedReachableViewController = failedReachableViewController
    showErrorOrReportNoInternet(errorMessage)
  }
  
  // Shows the response body from the known error with HTTP status code 422
  func showError422(failedReachableViewController: TegReachableViewController, bodyText: String?) {
    self.failedReachableViewController = failedReachableViewController
    message.showWithCloseButton(bodyText, inViewController: failedReachableViewController)
  }

  private func showNoInternetMessage() {
    if let viewController = failedReachableViewController {
      message.noInternet(viewController)
    }
  }

  func hidePreviousFailureMessage() {
    if let viewController = failedReachableViewController {
      message.hide(viewController)
    }
  }

  private func reloadFailedConnection() {
    if let failedLoader = failedLoader {
      failedLoader.startLoading()
    }

    failedReachableViewController?.failedLoader = nil
  }

  // MARK: tegReachabilityMessageDelegate_didTapReloadButton
  // --------------------------------

  func tegReachabilityMessageDelegate_didTapReloadButton() {
    reloadFailedConnection()
  }
}
