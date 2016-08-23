public struct Location {

  public let path: String
  public let arguments: [String: String]
  public let fragments: [String: AnyObject]
  public let payload: Any?

  public var scheme: String {
    return Compass.scheme
  }

  public init(path: String,
              arguments: [String: String] = [:],
              fragments: [String: AnyObject] = [:],
              payload: Any? = nil) {
    self.path = path
    self.arguments = arguments
    self.fragments = fragments
    self.payload = payload
  }
}
