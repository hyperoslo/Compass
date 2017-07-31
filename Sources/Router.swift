/// Possible error enums
///
/// - notFound: The route can not be found
/// - invalidArguments: The argument is not valid
public enum RouteError: Error {
  case notFound
  case invalidArguments(Location)
}

/// Anything conforming to Routable knows how to navigate to a certain location. Used by Router
public protocol Routable {

  /// Navigate to a location based on the current controller
  ///
  /// - Parameters:
  ///   - location: The location to go to
  ///   - currentController: The current controller
  /// - Throws: Throws RouteError if any
  func navigate(to location: Location, from currentController: CurrentController) throws
}

/// Anything conforming to ErrorRoutable knows how to handle route error. Used by Router
public protocol ErrorRoutable {

  func handle(routeError error: Error, from currentController: CurrentController)
}

/// A Router knows how to parse routing request and delegate handling to Routable
public struct Router: Routable {

  /// A map of route string and Routable
  public var routes = [String: Routable]()

  /// The error handler
  public var errorRoute: ErrorRoutable?

  public init() {}

  /// Navigate to a location based on the current controller
  ///
  /// - Parameters:
  ///   - location: The requested location
  ///   - currentController: The current controller
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
