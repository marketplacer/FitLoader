/**

Parses the known error message from server response.
The known error message is delivered in specific JSON format in a reponse with HTTP status code 422.

*/
struct TegReachabilityKnownErrorMessage {
  static func parse(bodyText: String, response: NSHTTPURLResponse) -> String? {
    if response.statusCode != 422 { return nil }
    
    if let dictionary = parseJsonToDictionary(bodyText) {
      return dictionary[TegReachabilityConstants.knownErrorMessageKeyName] as? String
    }
    
    return nil
  }
  
  private static func parseJsonToDictionary(text: String) -> NSDictionary? {
    if let encoded = text.dataUsingEncoding(NSUTF8StringEncoding) {
      do {
        return try NSJSONSerialization.JSONObjectWithData(encoded,
          options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary
      } catch _ {}
    }
    
    return nil // failed to convert text to Dictionary
  }
}
