import Foundation

public struct Route {

  public let route: String
  public let arguments: [String: String]
  public let fragments: [String: AnyObject]
}

public struct Compass {

  typealias Result = (route: String, arguments: [String: String],
    concreteMatchCount: Int, wildcardMatchCount: Int)

  private static var internalScheme = ""

  public static var delimiter: String = ":"

  public static var scheme: String {
    set { Compass.internalScheme = newValue }
    get { return "\(Compass.internalScheme)://" }
  }

  public static var routes = [String]()

  public static func parse(url: NSURL, fragments: [String : AnyObject] = [:]) -> Route? {

    let path = url.absoluteString.substringFromIndex(scheme.endIndex)

    guard !(path.containsString("?") || path.containsString("#")) else {
      return parseAsURL(url, fragments: fragments)
    }

    let results: [Result] = routes.flatMap {
      return findMatch($0, pathString: path)
    }.sort { (r1: Result, r2: Result) in
      if r1.concreteMatchCount == r2.concreteMatchCount {
        return r1.wildcardMatchCount > r2.wildcardMatchCount
      }

      return r1.concreteMatchCount > r2.concreteMatchCount
    }

    if let result = results.first {
      return Route(route: result.route, arguments: result.arguments, fragments: fragments)
    }

    return nil
  }

  static func parseAsURL(url: NSURL, fragments: [String : AnyObject] = [:]) -> Route? {
    guard let route = url.host else { return nil }

    let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)

    var arguments = [String : String]()

    urlComponents?.queryItems?.forEach { queryItem in
      arguments[queryItem.name] = queryItem.value
    }

    if let fragment = urlComponents?.fragment {
      arguments = fragment.queryParameters()
    }

    return Route(route: route, arguments: arguments, fragments: fragments)
  }

  static func findMatch(routeString: String, pathString: String)
    -> Result? {

    let routes = routeString.split(delimiter)
    let paths = pathString.split(delimiter)

    guard routes.count == paths.count else { return nil }

    var arguments: [String: String] = [:]
    var concreteMatchCount = 0
    var wildcardMatchCount = 0

    for (route, path) in zip(routes, paths) {
      if route.hasPrefix("{") {
        let key = route.replace("{", with: "").replace("}", with: "")
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

    return (route: routeString, arguments: arguments,
            concreteMatchCount: concreteMatchCount, wildcardMatchCount: wildcardMatchCount)
  }
}

private extension String {

    func queryParameters() -> [String: String] {
        var parameters = [String: String]()

        let separatorCharacters = NSCharacterSet(charactersInString: "&;")
        self.componentsSeparatedByCharactersInSet(separatorCharacters).forEach { (pair) in

            if let equalSeparator = pair.rangeOfString("=") {
                let name = pair.substringToIndex(equalSeparator.startIndex)
                let value = pair.substringFromIndex(equalSeparator.startIndex.advancedBy(1))
                let cleaned = value.stringByRemovingPercentEncoding ?? value

                parameters[name] = cleaned
            }
        }

        return parameters
    }

}
