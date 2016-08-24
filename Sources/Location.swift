public struct Location {

  public let path: String
  public let arguments: [String: String]
  public let payload: Any?

  public var scheme: String {
    return Compass.scheme
  }

  public init(path: String, arguments: [String: String] = [:], payload: Any? = nil) {
    self.path = path
    self.arguments = arguments
    self.payload = payload
  }
}
