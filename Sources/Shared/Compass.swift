import Foundation
import Sugar

public struct Compass {

  typealias Result = (route: String, arguments: [String: String], matchCount: Int)

  private static var internalScheme = ""

  public static var delimiter: String = ":"

  public static var scheme: String {
    set { Compass.internalScheme = newValue }
    get { return "\(Compass.internalScheme)://" }
  }

  public static var routes = [String]()

  public typealias ParseCompletion = (route: String, arguments: [String : String], fragments : [String : AnyObject]) -> Void

  public static func parse(url: NSURL, fragments: [String : AnyObject] = [:], completion: ParseCompletion) -> Bool {

    let path = url.absoluteString.substringFromIndex(scheme.endIndex)

    guard !(path.containsString("?") || path.containsString("#"))
      else { return parseAsURL(url, completion: completion) }

    let results: [Result] = routes.flatMap {
      return findMatch($0, pathString: path)
    }.sort {
      return $0.matchCount > $1.matchCount
    }

    if let result = results.first {
      completion(route: result.route, arguments: result.arguments, fragments: fragments)
      return true
    }

    return false
  }

  static func parseAsURL(url: NSURL, completion: ParseCompletion) -> Bool {
    guard let route = url.host else { return false }

    var arguments = [String : String]()

    [url.fragment, url.query].forEach {
      $0?.split("&").forEach {
        let pair = $0.split("=")
        arguments[pair[0]] = pair[1]
      }
    }

    completion(route: route, arguments: arguments, fragments: [:])

    return true
  }

  static func findMatch(routeString: String, pathString: String)
    -> Result? {

    let routes = routeString.split(delimiter)
    let paths = pathString.split(delimiter)

    var arguments: [String: String] = [:]

    var matchCount = 0

    for (route, path) in zip(routes, paths) {
      if route.hasPrefix("{") {
        let key = route.replace("{", with: "").replace("}", with: "")
        arguments[key] = path

        matchCount += 1
        continue
      }

      if route != path {
        return nil
      }

      matchCount += 1
    }
    
    return (route: routeString, arguments: arguments, matchCount: matchCount)
  }
}

