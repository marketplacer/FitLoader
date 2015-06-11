//
//  Store information about HTTP method for request type.
//

import Foundation
import MprHttp

public struct TegRequestTypeHttpMethod {
  private static let defaultMethod = TegHttpMethod.Get

  private static var data = [TegRequestType:TegHttpMethod]()

  public static func method(type: TegRequestType) -> TegHttpMethod {
    return data[type] ?? defaultMethod
  }
}
