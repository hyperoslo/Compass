import Foundation

/// The Navigator is used to parse Location from url, and navigate
public struct Navigator {
  fileprivate static var internalScheme = ""

  /// The delimiter used to split parts within url, default to :
  public static var delimiter: String = ":"

  /// The scheme used by Compass, usually it is your application scheme
  public static var scheme: String {
    set { Navigator.internalScheme = newValue }
    get { return "\(Navigator.internalScheme)://" }
  }

  /// A list of route strings
  public static var routes = [String]()

  /// Handle the location request
  public static var handle: ((Location) -> Void)?

  /// Parse Location from url
  ///
  /// - Parameters:
  ///   - url: The url to be parsed
  ///   - payload: The optional payload if you want to send in app objects
  /// - Returns: The Location that can be used
  public static func parse(url: URL, payload: Any? = nil) -> Location? {
    let path = String(url.absoluteString.suffix(from: scheme.endIndex))

    guard !(path.contains("?") || path.contains("#")) else {
      return parseComponents(url: url, payload: payload)
    }

    let results: [Result] = routes.flatMap {
      return findMatch(routeString: $0, pathString: path)
    }.sorted { (r1: Result, r2: Result) in
      if r1.concreteMatchCount == r2.concreteMatchCount {
        return r1.wildcardMatchCount > r2.wildcardMatchCount
      }

      return r1.concreteMatchCount > r2.concreteMatchCount
    }

    if let result = results.first {
      return Location(path: result.route, arguments: result.arguments, payload: payload)
    }

    return nil
  }


  /// Helper function to parse url if it has components and queryItems
  ///
  /// - Parameters:
  ///   - url: The url to be parsed
  ///   - payload: The optional payload if you want to send in app objects
  /// - Returns: The Location that can be used
  fileprivate static func parseComponents(url: URL, payload: Any? = nil) -> Location? {
    guard let route = url.host else { return nil }

    let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    var arguments = [String : String]()

    urlComponents?.queryItems?.forEach { queryItem in
      arguments[queryItem.name] = queryItem.value
    }

    if let fragment = urlComponents?.fragment {
      arguments = fragment.queryParameters()
    }

    return Location(path: route, arguments: arguments, payload: payload)
  }

  /// The Result used in the findMatch function
  fileprivate typealias Result = (
    route: String,
    arguments: [String: String],
    concreteMatchCount: Int,
    wildcardMatchCount: Int)

  /// Find the best match registed route for a certain route string
  ///
  /// - Parameters:
  ///   - routeString: The registered route string
  ///   - pathString: The path extracted from the requested url
  /// - Returns: The Result on how this pathString matches
  fileprivate static func findMatch(routeString: String, pathString: String) -> Result? {
    let routes = routeString.split(delimiter)
    let paths = pathString.split(delimiter)

    guard routes.count == paths.count else { return nil }

    var arguments: [String: String] = [:]
    var concreteMatchCount = 0
    var wildcardMatchCount = 0

    for (route, path) in zip(routes, paths) {
      if route.hasPrefix("{") {
        let key = route.replacingOccurrences(of: "{", with: "")
                       .replacingOccurrences(of: "}", with: "")
        arguments[key] = path

        wildcardMatchCount += 1
        continue
      }

      if route == path {
        concreteMatchCount += 1
      } else {
        return nil
      }
    }

    return (route: routeString,
            arguments: arguments,
            concreteMatchCount: concreteMatchCount,
            wildcardMatchCount: wildcardMatchCount)
  }
}

public extension Navigator {

  /// Navigate using urn
  ///
  /// - Parameters:
  ///   - urn: The urn
  ///   - payload: Optional payload
  /// - Throws: RouteError if the routing fails
  public static func navigate(urn: String, payload: Any? = nil) throws {
    let encodedUrn = PercentEncoder.encode(string: urn, allowedCharacters: delimiter)
    guard let url =  URL(string: "\(scheme)\(encodedUrn)") else {
      throw RouteError.notFound
    }

    try navigate(url: url, payload: payload)
  }

  /// Navigate using url
  ///
  /// - Parameters:
  ///   - urn: The url
  ///   - payload: Optional payload
  /// - Throws: RouteError if the routing fails
  public static func navigate(url: URL, payload: Any? = nil) throws {
    guard let location = parse(url: url, payload: payload) else {
      throw RouteError.notFound
    }

    try navigate(location: location)
  }

  /// Navigate using location
  ///
  /// - Parameters:
  ///   - urn: The urn
  ///   - payload: Optional payload
  /// - Throws: RouteError if the routing fails
  public static func navigate(location: Location) throws {
    handle?(location)
  }
}
