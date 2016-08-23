import Foundation

extension String {

  func split(delimiter: String) -> [String] {
    let components = componentsSeparatedByString(delimiter)
    return components != [""] ? components : []
  }

  func replace(string: String, with withString: String) -> String {
    return stringByReplacingOccurrencesOfString(string, withString: withString)
  }

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
