import Foundation
import Sugar

public struct Compass {

  private static var internalScheme = ""

  public static var scheme: String {
    set { Compass.internalScheme = newValue }
    get { return "\(Compass.internalScheme)://" }
  }

  public static var routes = [String]()

  public typealias ParseCompletion = (route: String, arguments: [String : String]) -> Void

  public static func parse(url: NSURL, completion: ParseCompletion) -> Bool {
    var result = false
    let query = url.absoluteString.substringFromIndex(scheme.endIndex)

    guard !(query.containsString("?") || query.containsString("#"))
      else { return parseAsURL(url, completion: completion) }

    for route in routes.sort({ $0 < $1 }) {
      guard let prefix = route.split("{").first else { continue }

      if query.hasPrefix(prefix) || prefix.hasPrefix(query) {
        let queryArguments = query.replace(prefix, with: "").split(":")
        let routeArguments = route.split(":").filter { $0.containsString("{") }

        var arguments = [String : String]()

        if queryArguments.count == routeArguments.count {
          for (index, key) in routeArguments.enumerate() {
            arguments[String(key.characters.dropFirst().dropLast())] = index <= queryArguments.count && "\(query):" != prefix
              ? queryArguments[index] : nil
          }
          completion(route: route, arguments: arguments)

          result = true
          break
        }
      }
    }

    return result
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

    completion(route: route, arguments: arguments)

    return true
  }
}

