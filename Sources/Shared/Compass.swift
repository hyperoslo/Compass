import Foundation
import Sugar

public struct Compass {

  private static var internalScheme = ""

  public static var scheme: String {
    set { Compass.internalScheme = newValue }
    get { return "\(Compass.internalScheme)://" }
  }

  public static var routes = [String]()

  public typealias ParseCompletion = (route: String, arguments: [String : String], query : [String : AnyObject]) -> Void

  public static func parse(url: NSURL, query: [String : AnyObject] = [:], completion: ParseCompletion) -> Bool {
    var result = false
    let path = url.absoluteString.substringFromIndex(scheme.endIndex)

    guard !(path.containsString("?") || path.containsString("#"))
      else { return parseAsURL(url, completion: completion) }

    for route in routes.sort({ $0 < $1 }) {
      guard let prefix = route.split("{").first else { continue }

      if path.hasPrefix(prefix) || prefix.hasPrefix(path) {
        let pathArguments = path.replace(prefix, with: "").split(":")
        let routeArguments = route.split(":").filter { $0.containsString("{") }

        var arguments = [String : String]()

        if pathArguments.count == routeArguments.count {
          for (index, key) in routeArguments.enumerate() {
            arguments[String(key.characters.dropFirst().dropLast())] = index <= pathArguments.count && "\(path):" != prefix
              ? pathArguments[index] : nil
          }

          completion(route: route, arguments: arguments, query: query)

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

    completion(route: route, arguments: arguments, query: [:])

    return true
  }
}

