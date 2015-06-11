import UIKit

@objc
class ReachableViewControllerMock: TegReachableViewController {  
  init() {
    view = UIView()
    
    // Create views for layout guides
    
    let topLayoutGuideView = LayoutGuideMock()
    topLayoutGuide = topLayoutGuideView
    view.addSubview(topLayoutGuideView)
    
    let bottomLayoutGuideView = LayoutGuideMock()
    bottomLayoutGuide = bottomLayoutGuideView
    view.addSubview(bottomLayoutGuideView)
  }
  
  var failedLoader: TegReachabilityLoader?
  var view: UIView!
  var topLayoutGuide: UILayoutSupport
  var bottomLayoutGuide: UILayoutSupport
}