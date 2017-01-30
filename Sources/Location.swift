public struct Location {

  public let path: String
  public let arguments: [String: String]
  public let payload: Any?

  public var scheme: String {
    return Navigator.scheme
  }

  public init(path: String, arguments: [String: String] = [:], payload: Any? = nil) {
    self.path = path
    self.payload = payload

    var decodedArguments = [String: String]()
    arguments.forEach { (key, value) in
      decodedArguments[key] = value.compass_decoded()
    }

    self.arguments = decodedArguments
  }
}
