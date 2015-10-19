//
//  The struct keeps URL to the server.
//

import Foundation

public struct TegRequestUrl {

  private func host(type: TegRequestType) -> String {
    switch type {
    case .MyAccount:
      return "http://httpstat.us"
    case .Error422:
      return "https://yaushop.com"
    default:
      return "https://dl.dropboxusercontent.com"
    }
  }

  public func url(requestType: TegRequestType, params: [String: String]?) -> String {
    let urlPath = TegRequestUrl.makePath(requestType, values: params)
    return "\(host(requestType))/\(urlPath)"
  }

  public static func makePath(requestType: TegRequestType, values: [String: String]?) -> String {
    var url = requestType.rawValue

    if let values = values {
      for (name, value) in values {
        let encodedValue = TegUrlEncoder.encodeUrlParameter(value)
        url = url.stringByReplacingOccurrencesOfString("{\(name)}", withString: encodedValue)
      }
    }

    return url
  }
}