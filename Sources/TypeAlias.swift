#if os(OSX)
  import Cocoa
#else
  import UIKit
#endif

#if os(OSX)
  public typealias CurrentController = NSViewController
#else
  public typealias CurrentController = UIViewController
#endif
