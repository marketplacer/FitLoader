//
//  Sends an HTTP request.
//
//  Note: callbacks are called in the main queue.
//

import Foundation

class TegDownloaderMainQueue {
  class func load(requestIdentity: TegHttpRequestIdentity,
    onSuccess: (NSData, NSHTTPURLResponse)->(),
    onError: ((NSError, NSHTTPURLResponse?)->())? = nil,
    onAlways: (()->())? = nil) -> NSURLSessionDataTask? {

    return TegDownloaderAsync.load(requestIdentity,
      onSuccess: { data, response in
        TegQ.main { onSuccess(data, response) }
      },
      onError: { error, response in
        if let onError = onError {
          TegQ.main { onError(error, response) }
        }
      },
      onAlways: {
        if let onAlways = onAlways {
          TegQ.main { onAlways() }
        }
      }
    )
  }
}
