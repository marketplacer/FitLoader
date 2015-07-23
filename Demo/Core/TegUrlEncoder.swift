import Foundation

public class TegUrlEncoder {
  public class func encodeUrlParameter(value: String) -> String {
    let raw: NSString = value
    
    return CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, raw,
      "[].",":/?&=;+!@#$()',*",
      CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) as String
  }
}
