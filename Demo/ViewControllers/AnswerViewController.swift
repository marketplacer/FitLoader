import UIKit
import MprHttp
import FitLoader

class AnswerViewController: UIViewController, TegReachableViewController,
  UINavigationControllerDelegate {
  
  weak var failedLoader: TegReachabilityLoader?
 
  var loader: TegReachabilityLoader?
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.delegate = self
    label.text = nil
    activityIndicator.hidden = true
    load()
  }
  
  private func load() {
    if loader != nil { return } // already loading
    
    let requestIdentity = TegRequestType.Answer.identity()

    let newLoadder = TegReachabilityLoader(httpText: TegHttpText(),
      requestIdentity: requestIdentity,
      viewController: self,
      authentication: nil) { [weak self] text in
      
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
  
  // MARK: UINavigationControllerDelegate
  // --------------------------------
  
  func navigationController(navigationController: UINavigationController,
    willShowViewController viewController: UIViewController, animated: Bool) {
      
    TegReachability.shared.reloadOldFailedRequest(viewController)
  }
}

