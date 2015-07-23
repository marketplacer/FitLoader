import UIKit
import Dodo

class TegReachabilityMessage {
  weak var delegate: TegReachabilityMessageDelegate?
  
  /// Shows an expected error message with a close button.
  func showWithCloseButton(message: String?,
    inViewController viewController: TegReachableViewController) {
      
    let actualMessage = message ?? TegReachabilityConstants.errorMessages.unexpectedResponse
    show(actualMessage, inViewController: viewController, withIcon: .Close)
  }
  
  /// Show "No Internet connection" message with no button
  func noInternet(viewController: TegReachableViewController) {
    show(TegReachabilityConstants.errorMessages.noInternet,
      inViewController: viewController, withIcon: nil)
  }
  
  /// Show an unexpected message with a reload icon
  func showWithReloadButton(message: String,
    inViewController viewController: TegReachableViewController) {
      
    show(message, inViewController: viewController, withIcon: .Reload)
  }
  
  func hide(viewController: TegReachableViewController) {
    viewController.view.dodo.hide()
  }
  
  private func show(message: String, inViewController viewController: TegReachableViewController,
    withIcon icon: DodoIcons?) {

    let view = viewController.view
    view.dodo.topLayoutGuide = viewController.topLayoutGuide
    view.dodo.bottomLayoutGuide = viewController.bottomLayoutGuide
    view.dodo.style.leftButton.icon = nil
    view.dodo.style.leftButton.onTap = nil
      
    if let icon = icon {
      view.dodo.style.leftButton.icon = icon
      
      switch icon {
      case .Reload:
        view.dodo.style.leftButton.onTap = { [weak self] in
          self?.delegate?.tegReachabilityMessageDelegate_didTapReloadButton()
        }
      case .Close:
        view.dodo.style.leftButton.hideOnTap = true
      }
    }
      
    view.dodo.error(message)
  }
}