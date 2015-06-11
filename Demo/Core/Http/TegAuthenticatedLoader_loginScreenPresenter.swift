//
//  Shows a login screen for a 401 Unauthorized HTTP response.
//  This is a plugin class for the Authenticated Loader control.
//

import UIKit

public class TegAuthenticatedLoader_loginScreenPresenter {
  public init() { }

  public func present(viewController: UIViewController,
    delegate: TegAuthenticatedLoader_loginDelegate) {

    TegViewControllerNames.Login.present(viewController) { loginViewController in
      if let loginViewController = loginViewController as? LoginViewController {
        loginViewController.delegate = delegate
      }
    }
  }
}
