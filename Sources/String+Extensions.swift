import Foundation

extension String {

  /// Safely split components based on delimiter
  ///
  /// - Parameter delimiter: The delimiter
  /// - Returns: An array of parts
  func split(_ delimiter: String) -> [String] {
    let components = self.components(separatedBy: delimiter)
    return components != [""] ? components : []
  }

  /// Get query parameters if any
  ///
  /// - Returns: A map of query key and content
  func queryParameters() -> [String: String] {
    var parameters = [String: String]()

    let separatorCharacters = CharacterSet(charactersIn: "&;")
    self.components(separatedBy: separatorCharacters).forEach { (pair) in

      if let equalSeparator = pair.range(of: "=") {
        let name = String(pair.prefix(upTo: equalSeparator.lowerBound))
        let value = String(pair.suffix(from: pair.index(equalSeparator.lowerBound, offsetBy: 1)))
        let cleaned = value.removingPercentEncoding ?? value

        parameters[name] = cleaned
      }
    }

    return parameters
  }
}
