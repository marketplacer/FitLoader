import Foundation

public class TegUrlEncoder {
  public class func encodeUrlParameter(value: String) -> String {
    var raw: NSString = value
    var str = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, raw, "[].",":/?&=;+!@#$()',*",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) as? String
   
    
    return str ?? ""
  }
}
