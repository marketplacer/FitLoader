//
//  List of json file names containing simulated server response used in testing.
//

import Foundation

public struct TegMockedHttpRequests {
  //
  // This array contains requests that are loaded from local JSON file and not from the server.
  // It is useful for developing and testing UI that does not yet have a server side component.
  //
  // Tip: make this array empty before uploading to the App Store to avoid extra stress.
  //
  public static let mockedRequests: [TegRequestType] = [ ]

  static let testJsonFiles: [TegRequestType: String] = [
    TegRequestType.Error422: "hello.json"
  ]
  
  public static func testJsonFile(request: TegRequestType) -> String? {
    return testJsonFiles[request]
  }
}

