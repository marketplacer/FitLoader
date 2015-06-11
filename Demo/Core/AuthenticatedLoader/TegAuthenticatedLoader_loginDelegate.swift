import UIKit

public protocol TegAuthenticatedLoader_loginDelegate: class {
  func loginDelegate_didLogIn()
  func loginDelegate_didCancel()
}
