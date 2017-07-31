#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

#if os(OSX)
  public typealias CurrentController = NSViewController

  /// Tell the application to open the url
  ///
  /// - Parameter url: The requested url
  func open(url: URL) {
    NSWorkspace.shared().open(url)
  }
#else
  public typealias CurrentController = UIViewController

  /// Tell the application to open the url
  ///
  /// - Parameter url: The requested url
  func open(url: URL) {
    UIApplication.shared.openURL(url)
  }
#endif
