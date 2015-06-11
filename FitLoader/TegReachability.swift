//
//  Get information about current network status.
//  It is used to show 'no internet connection' message in view controllers.
//

import UIKit

public class TegReachability: NSObject, TegReachabilityMessageDelegate {
  public static let shared = TegReachability()

  var reachability: Reachability?

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
      return status.value != NotReachable.value
    }

    return false
  }

  func startListeningForNetworkStatusChanges(hostName: String) {
    if listeningForNetworkStatusChanges { return } // already setup

    let newReachability = Reachability(hostName: hostName)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: newReachability)

    newReachability.startNotifier()
    reachability = newReachability
  }

  func stopListeningForNetworkStatusChanges(hostName: String) {
    if !listeningForNetworkStatusChanges { return } // not listening

    NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: reachability)

    reachability.map { $0.stopNotifier() }
    reachability = nil
  }

  func reachabilityChanged(notification: NSNotification) {
    TegQ.main { [weak self] in
      self?.reloadFailedRequestAndUpdateStatusMessage()
    }
  }

  /// Reloads failed request from a reachable view controller, if any.
  func reloadOldFailedRequest(viewController: UIViewController) {
    if let reachableViewController = viewController as? TegReachableViewController {
      failedReachableViewController = reachableViewController
      reloadFailedRequestAndUpdateStatusMessage()
    }
  }

  private func reloadFailedRequestAndUpdateStatusMessage() {
    if failedLoader != nil { // there is a pending failed request waiting to be reloaded
      reloadFailedConnection()
    } else {
      hideMessage()
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

  private func hideMessage() {
    if let viewController = failedReachableViewController as? UIViewController {
      message.hide(viewController)
    }
  }

  private func reloadFailedConnection() {
    if let failedLoader = failedLoader {
      hideMessage()
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
