import UIKit

class LayoutGuideMock: UIView, UILayoutSupport {
  init() {
    super.init(frame: CGRect())
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  var lengthMock: CGFloat = 0
  
  var length: CGFloat {
    return lengthMock
  }
}