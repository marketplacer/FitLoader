import UIKit
import MprHttp
import FitLoader

class MyAccountViewController: UIViewController, TegReachableViewController,
  TegAuthenticatedLoader_loginDelegate {

  weak var failedLoader: TegReachabilityLoader?
  var loader: TegReachabilityLoader?

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()

    label.text = nil
    activityIndicator.hidden = true
    load(TegRequestType.MyAccount)
  }

  private func load(requestType: TegRequestType) {
    let requestIdentity = requestType.identity()

    let newLoadder = TegAuthenticatedLoader(httpText: TegHttpText(),
      requestIdentity: requestIdentity,
      viewController: self,
      authentication: nil,
      delegate: self,
      loginScreenPresenter: TegAuthenticatedLoader_loginScreenPresenter()) {
        
      [weak self] text in

      self?.label.text = text
      return true
    }

    newLoadder.onStarted = { [weak self] in
      self?.activityIndicator.hidden = false
    }
    
    newLoadder.onFinishedWithSuccessOrError = { [weak self] in
      self?.activityIndicator.hidden = true
    }

    newLoadder.startLoading()

    loader = newLoadder
  }
  
  // MARK: TegAuthenticatedLoader_loginDelegate
  // -----------------------
  
  func loginDelegate_didLogIn() {
    load(TegRequestType.MyAccountAuthenticated)
  }
  
  func loginDelegate_didCancel() {
    navigationController?.popViewControllerAnimated(true)
  }
}
