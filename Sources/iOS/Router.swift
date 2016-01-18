import UIKit

public struct Router {

  public var routes = [String: Routable]()

  public init() {}

  public func navigate(route: String, arguments: [String: String], navigationController: UINavigationController?) {
    guard let route = routes[route] else { return }

    route.resolve(arguments, navigationController: navigationController)
  }
}
