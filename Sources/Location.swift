/// Used to encapsulate a location request
public struct Location {

  /// The urn
  public let path: String

  /// The arguments if any
  public let arguments: [String: String]

  /// An optional payload if you want to send in app objects
  public let payload: Any?

  /// The application scheme
  public var scheme: String {
    return Navigator.scheme
  }

  /// Construct a Location
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
