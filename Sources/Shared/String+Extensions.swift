extension String {

  func split(delimiter: String) -> [String] {
    let components = componentsSeparatedByString(delimiter)
    return components != [""] ? components : []
  }

  func replace(string: String, with withString: String) -> String {
    return stringByReplacingOccurrencesOfString(string, withString: withString)
  }
}
