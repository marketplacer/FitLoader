//
//  Present view controller modally using its storyboard ID.
//

import UIKit

class TegPresentViewController {
  class func present(viewController: UIViewController,
    viewControllerName: TegViewControllerNames,
    beforePresenting: ((UIViewController)->())? = nil) -> UIViewController? {

    if let unwrapedViewController = instantiateViewControllerWithIdentifier(viewControllerName) {
      beforePresenting?(unwrapedViewController)
      viewController.presentViewController(unwrapedViewController, animated: true, completion: nil)
      return unwrapedViewController
    }

    return nil
  }
  
  class func pushToNavigationController(viewController: UIViewController,
    viewControllerName: TegViewControllerNames, animated: Bool = true,
    beforePresenting: ((UIViewController)->())? = nil) -> UIViewController? {
      
    if let unwrapedViewController = instantiateViewControllerWithIdentifier(viewControllerName) {

      beforePresenting?(unwrapedViewController)

      viewController.navigationController?.pushViewController(unwrapedViewController,
        animated: animated)
        
      return unwrapedViewController
    }
      
    return nil
  }
  
  class func instantiateViewControllerWithIdentifier(viewControllerName: TegViewControllerNames)
    -> UIViewController? {
    
    let storyboardName = viewControllerName.storyboardName
    let bundle = NSBundle.mainBundle()
    let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: bundle)
      
    return storyboard.instantiateViewControllerWithIdentifier(viewControllerName.rawValue)
  }
}
