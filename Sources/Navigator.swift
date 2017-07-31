import Foundation

/// The Navigator is used to parse Location from url, and navigate
public struct Navigator {

  /// The Result used in the findMatch function
  typealias Result = (
    route: String,
    arguments: [String: String],
    concreteMatchCount: Int,
    wildcardMatchCount: Int)

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

  /// Parse Location from url
  ///
  /// - Parameters:
  ///   - url: The url to be parsed
  ///   - payload: The optional payload if you want to send in app objects
  /// - Returns: The Location that can be used
  public static func parse(url: URL, payload: Any? = nil) -> Location? {
    let path = url.absoluteString.substring(from: scheme.endIndex)

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
  static func parseComponents(url: URL, payload: Any? = nil) -> Location? {
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

  /// Find the best match registed route for a certain route string
  ///
  /// - Parameters:
  ///   - routeString: The registered route string
  ///   - pathString: The path extracted from the requested url
  /// - Returns: The Result on how this pathString matches
  static func findMatch(routeString: String, pathString: String) -> Result? {
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

extension Navigator {

  /// Parse an urn to be Compass friendly URL
  ///
  /// - Parameters:
  ///   - urn: The requested urn
  ///   - scheme: The application scheme
  /// - Returns: The URL to be ready used by Compass
  public static func compassURL(urn: String, scheme: String = Navigator.scheme) -> URL? {
    return URL(string: "\(scheme)\(urn.compass_encoded())")
  }


  /// Navigate by telling the application to open a url
  ///
  /// - Parameters:
  ///   - urn: The requested urn
  ///   - scheme: The application scheme
  public static func navigate(to urn: String, scheme: String = Navigator.scheme) {
    guard let url = compassURL(urn: urn, scheme: scheme) else { return }
    open(url: url)
  }
}
