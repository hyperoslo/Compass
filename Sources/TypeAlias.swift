#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

#if os(OSX)
  public typealias Controller = NSViewController

  func openURL(_ url: URL) {
    NSWorkspace.shared().open(url)
  }
#else
  public typealias Controller = UIViewController

  func openURL(_ url: Foundation.URL) {
    UIApplication.shared.openURL(url)
  }
#endif
