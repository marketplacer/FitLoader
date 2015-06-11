//
//  Loads data from server. Shows a login screen if server returns 401 Unauthorized response.
//

import UIKit
import MprHttp
import FitLoader

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

    onError = handleError
    self.delegate = delegate
  }

  private func handleError(error: NSError, response: NSHTTPURLResponse?, bodyText: String?) -> Bool {

    // Show login screen if reponse status code is 401
    if let response = response,
      viewController = reachableViewController as? UIViewController,
      currentDelegate = delegate
      where response.statusCode == 401 {

      loginScreenPresenter.present(viewController, delegate: currentDelegate)
      return true
    }

    return false
  }
}
