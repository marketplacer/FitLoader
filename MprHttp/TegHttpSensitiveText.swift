//
// Used in loging of HTTP requests. Hides the message if it contains sensitive content.
//

public struct TegHttpSensitiveText {
  private static let sensitiveMessages = [
    "token",
    "nonce",
    "key"
  ]
  
  public static func hideSensitiveContent(text: String) -> String {
    if isSensitive(text) {
      return "****** hidden ******"
    }
    
    return text
  }
  
  public static func isSensitive(text: String) -> Bool {
    for substring in sensitiveMessages {
      if TegString.contains(text, substring: substring, ignoreCase: true) {
        return true
      }
    }
    
    return false
  }
}