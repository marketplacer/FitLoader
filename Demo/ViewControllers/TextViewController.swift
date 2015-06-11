import UIKit
import MprHttp
import FitLoader

class TextViewController: UIViewController, TegReachableViewController {
  
  weak var failedLoader: TegReachabilityLoader?
  var loader: TegReachabilityLoader?
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    label.text = nil
    activityIndicator.hidden = true
    load()
  }
  
  private func load() {
    if loader != nil { return } // already loading
    
    let requestIdentity = TegRequestType.Text.identity()
    
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
}
