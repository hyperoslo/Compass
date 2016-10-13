public enum RouteError: Error {
  case notFound
  case invalidArguments(Location)
  case invalidPayload(Location)
}

public protocol Routable {

  func navigate(to location: Location, from currentController: CurrentController) throws
}

public protocol ErrorRoutable {

  func handle(routeError error: Error, from currentController: CurrentController)
}

public struct Router: Routable {

  public var routes = [String: Routable]()
  public var errorRoute: ErrorRoutable?

  public init() {}

  public func navigate(to location: Location, from currentController: CurrentController) {
    guard let route = routes[location.path] else {
      errorRoute?.handle(routeError: RouteError.notFound, from: currentController)
      return
    }

    do {
      try route.navigate(to: location, from: currentController)
    } catch {
      errorRoute?.handle(routeError: error, from: currentController)
    }
  }
}
