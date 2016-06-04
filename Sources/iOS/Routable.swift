import UIKit

public protocol Routable {

  func resolve(arguments: [String: String], fragments: [String : AnyObject], currentController: UIViewController)
}
