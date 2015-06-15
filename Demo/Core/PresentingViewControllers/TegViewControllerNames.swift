import UIKit

enum TegViewControllerNames: String {
  case Login = "loginViewController"

  var storyboardName: TegStoryboardNames {
    for (storyboardName, viewControllerNames) in TegStoryboardNames.viewControllers {
      if viewControllerNames.contains(self) { return storyboardName }
    }
    
    return TegStoryboardNames.Main
  }
  
  func present(fromViewController: UIViewController,
    beforePresenting: ((UIViewController)->())? = nil) -> UIViewController? {
  
    return TegPresentViewController.present(fromViewController, viewControllerName: self,
        beforePresenting: beforePresenting)
  }
  
  func pushToNavigationController(fromViewController: UIViewController, animated: Bool = true,
    beforePresenting: ((UIViewController)->())? = nil) -> UIViewController? {

    return TegPresentViewController.pushToNavigationController(fromViewController,
      viewControllerName: self, animated: animated, beforePresenting: beforePresenting)
  }
  
  func instantiateViewController() -> UIViewController? {
    return TegPresentViewController.instantiateViewControllerWithIdentifier(self)
  }
}