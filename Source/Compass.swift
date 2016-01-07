import UIKit
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
      guard let prefix = (route.characters
        .split { $0 == "{" }
        .map(String.init))
        .first else { continue }

      if query.hasPrefix(prefix) || prefix.hasPrefix(query) {
        let queryString = query.stringByReplacingOccurrencesOfString(prefix, withString: "")
        let queryArguments = splitString(queryString, delimiter: ":")
        let routeArguments = splitString(route, delimiter: ":").filter { $0.containsString("{") }

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
      splitString($0, delimiter: "&").forEach {
        let pair = splitString($0, delimiter: "=")
        arguments[pair[0]] = pair[1]
      }
    }

    completion(route: route, arguments: arguments)

    return true
  }

  public static func navigate(urn: String, scheme: String = Compass.scheme) {
    let stringURL = "\(scheme)\(urn)"
    guard let url = NSURL(string: stringURL) else { return }

    UIApplication.sharedApplication().openURL(url)
  }

  // MARK: - Private Helpers

  private static func splitString(string: String?, delimiter: Character) -> [String] {
    guard let string = string else { return [] }

    return string.characters
      .split { $0 == delimiter }
      .map(String.init)
  }
}

