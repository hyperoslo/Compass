public protocol Routable {

  func resolve(arguments: [String: String],
               fragments: [String : AnyObject],
               currentController: Controller)
}

public struct Router {

  public var routes = [String: Routable]()

  public init() {}

  public func navigate(route: String,
                       arguments: [String: String],
                       fragments: [String : AnyObject] = [:],
                       from controller: Controller) {
    guard let route = routes[route] else { return }
    route.resolve(arguments, fragments: fragments, currentController: controller)
  }
}

