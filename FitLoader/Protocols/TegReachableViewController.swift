import UIKit

@objc
public protocol TegReachableViewController: class {
  weak var failedLoader: TegReachabilityLoader? { get set } // weak to avoid circular reference
  var view: UIView! { get set }
  var topLayoutGuide: UILayoutSupport { get }
  var bottomLayoutGuide: UILayoutSupport { get }
}
