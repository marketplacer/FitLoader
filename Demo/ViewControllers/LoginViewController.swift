import UIKit

class LoginViewController: UIViewController {
  weak var delegate: TegAuthenticatedLoader_loginDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func onLoginTapped(sender: AnyObject) {
    dismissViewControllerAnimated(true) { [weak self] in
      self?.delegate?.loginDelegate_didLogIn()
    }
  }

  @IBAction func onCancelTapped(sender: AnyObject) {
    dismissViewControllerAnimated(true) { [weak self] in
      self?.delegate?.loginDelegate_didCancel()
    }
  }
}