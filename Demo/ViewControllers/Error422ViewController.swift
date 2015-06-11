

import UIKit

class Error422ViewController: UIViewController, TegReachableViewController {
  weak var failedLoader: TegReachabilityLoader?
  var loader: TegReachabilityLoader?
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    activityIndicator.hidden = true
    load()
  }
  
  private func load() {
    if loader != nil { return } // already loading
    
    let requestIdentity = TegRequestType.Error422.identity()
    
    let newLoadder = TegReachabilityLoader(httpText: TegHttpText(),
      requestIdentity: requestIdentity,
      viewController: self,
      authentication: nil) { text in
        
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
}
