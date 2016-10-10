#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

#if os(OSX)
  public typealias CurrentController = NSViewController

  func open(url: URL) {
    NSWorkspace.shared().open(url)
  }
#else
  public typealias CurrentController = UIViewController

  func open(url: URL) {
    UIApplication.shared.openURL(url)
  }
#endif
