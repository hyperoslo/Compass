import UIKit

public protocol Routable {

  func resolve(arguments: [String: String], navigationController: UINavigationController?)
}
