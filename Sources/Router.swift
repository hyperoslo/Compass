public protocol Routable {

  func navigate(to location: Location, from currentController: Controller) throws
}

public protocol ErrorRoutable {

  func handle(routeError: ErrorType, from currentController: Controller)
}

public enum RouteError: ErrorType {
  case NotFound
}

public struct Router: Routable {

  public var routes = [String: Routable]()
  public var errorRoute: ErrorRoutable?

  public init() {}

  public func navigate(to location: Location, from currentController: Controller) {
    guard let route = routes[location.path] else {
      errorRoute?.handle(RouteError.NotFound, from: currentController)
      return
    }

    do {
      try route.navigate(to: location, from: currentController)
    } catch {
      errorRoute?.handle(error, from: currentController)
    }
  }
}
