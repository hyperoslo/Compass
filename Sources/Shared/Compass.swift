import Foundation
import Sugar

public struct Compass {

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

    let results = routes.flatMap {
      return findMatch($0, pathString: path)
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

  static func findMatch(routeString: String, pathString: String) -> (route: String, arguments: [String: String])? {
    let routes = routeString.split(delimiter)
    let paths = pathString.split(delimiter)

    var arguments: [String: String] = [:]

    for (route, path) in zip(routes, paths) {
      if route.hasPrefix("{") {
        let key = route.replace("{", with: "").replace("}", with: "")
        arguments[key] = path

        continue
      }

      if route != path {
        return nil
      }
    }
    
    return (route: routeString, arguments: arguments)
  }
}

