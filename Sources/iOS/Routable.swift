import UIKit

public protocol Routable {

  func resolve(arguments: [String: String], currentController: UIViewController)
}
