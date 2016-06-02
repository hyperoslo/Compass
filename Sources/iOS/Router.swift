import UIKit

public struct Router {

  public var routes = [String: Routable]()

  public init() {}

  public func navigate(route: String, arguments: [String: String], query: [String : AnyObject] = [:], from controller: UIViewController) {
    guard let route = routes[route] else { return }

    route.resolve(arguments, query: query, currentController: controller)
  }
}
