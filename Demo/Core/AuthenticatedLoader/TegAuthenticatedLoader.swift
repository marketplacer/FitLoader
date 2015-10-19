//
//  Loads data from server. Shows a login screen if server returns 401 Unauthorized response.
//

import UIKit
import FitLoader
import MprHttp

public class TegAuthenticatedLoader: TegReachabilityLoader {
  private weak var delegate: TegAuthenticatedLoader_loginDelegate?

  private let loginScreenPresenter: TegAuthenticatedLoader_loginScreenPresenter

  public init(httpText: TegHttpText,
    requestIdentity: TegHttpRequestIdentity,
    viewController: TegReachableViewController,
    authentication: TegReachabilityAuthentication?,
    delegate: TegAuthenticatedLoader_loginDelegate,
    loginScreenPresenter: TegAuthenticatedLoader_loginScreenPresenter,
    onSuccess: (String)->(Bool)) {

    self.loginScreenPresenter = loginScreenPresenter

    super.init(
      httpText: httpText,
      requestIdentity: requestIdentity,
      viewController: viewController,
      authentication: authentication,
      onSuccess: onSuccess)

    onUnauthorized = handleUnauthorizedError
    self.delegate = delegate
  }

  private func handleUnauthorizedError(error: NSError?,
    response: NSHTTPURLResponse?, bodyText: String?) {

    // Show login screen for unauthorized response
    if let viewController = reachableViewController as? UIViewController,
      currentDelegate = delegate {

      loginScreenPresenter.present(viewController, delegate: currentDelegate)
    }
  }
}
