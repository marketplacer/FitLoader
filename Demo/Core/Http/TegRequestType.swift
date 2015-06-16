//
//  Lists all HTTP request types for the app.
//
//  Each request type has a name of local JSON file. This JSON is used when testing in 'fake HTTP' mode.
//

import Foundation
import MprHttp

public enum TegRequestType: String {
  case Answer = "u/11143285/bikeexchange/reachability_notification/answer_screen.txt"
  case MyAccount = "401"
  case MyAccountAuthenticated = "u/11143285/bikeexchange/reachability_notification/my_account.txt"
  case Text = "u/11143285/bikeexchange/reachability_notification/text.txt"
  case Error422 = "api/v1/demo/known_error"

  var httpMethod: TegHttpMethod {
    return TegRequestTypeHttpMethod.method(self)
  }
  
  var contentType: TegHttpContentType {
    return TegHttpContentType.Json
  }

  func identity(params: [String: String]? = nil,
    requestBodyText: String? = nil) -> TegHttpRequestIdentity {

      let url = TegRequestUrl().url(self, params: params)
      var requestBody: NSData? = requestBodyText?.dataUsingEncoding(NSUTF8StringEncoding)

      return TegHttpRequestIdentity(
        url: url,
        method: httpMethod,
        requestBody: requestBody,
        contentType: contentType,
        httpHeaders: [],
        mockedResponse: nil
      )
  }
}