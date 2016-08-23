#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

#if os(OSX)
  public typealias Controller = NSViewController

  func openURL(URL: NSURL) {
    NSWorkspace.sharedWorkspace().openURL(URL)
  }
#else
  public typealias Controller = UIViewController

  func openURL(URL: NSURL) {
    UIApplication.sharedApplication().openURL(URL)
  }
#endif
