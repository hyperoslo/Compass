#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

#if os(OSX)
  public typealias Controller = NSViewController

  func open(url: URL) {
    NSWorkspace.shared().open(url)
  }
#else
  public typealias Controller = UIViewController

  func open(url: URL) {
    UIApplication.shared.openURL(url)
  }
#endif
