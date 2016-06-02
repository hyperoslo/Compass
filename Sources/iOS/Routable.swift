import UIKit

public protocol Routable {

  func resolve(arguments: [String: String], query: [String : AnyObject], currentController: UIViewController)
}
