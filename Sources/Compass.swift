import Foundation

public struct Compass {

  typealias Result = (
    route: String,
    arguments: [String: String],
    concreteMatchCount: Int,
    wildcardMatchCount: Int)

  fileprivate static var internalScheme = ""
  public static var delimiter: String = ":"

  public static var scheme: String {
    set { Compass.internalScheme = newValue }
    get { return "\(Compass.internalScheme)://" }
  }

  public static var routes = [String]()

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

extension Compass {

  public static func navigate(to urn: String, scheme: String = Compass.scheme) {
    guard let url = URL(string: "\(scheme)\(urn)") else { return }
    open(url: url)
  }
}
