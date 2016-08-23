public protocol Routable {

  func navigate(to location: Location, from currentController: Controller)
}

public struct Router: Routable {

  public var routes = [String: Routable]()

  public init() {}

  public func navigate(to location: Location, from currentController: Controller) {
    guard let route = routes[location.path] else { return }
    route.navigate(to: location, from: currentController)
  }
}
