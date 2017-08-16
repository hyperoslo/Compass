/// An encapsulated location request, used for navigate based on the registed routes.
/// You can either construct it or call Navigator.parse(url).
public struct Location {

  /// The urn
  public let path: String

  /// The arguments if any
  public let arguments: [String: String]

  /// An optional payload if you want to send in app objects
  public let payload: Any?

  /// Construct a Location
  public init(path: String, arguments: [String: String] = [:], payload: Any? = nil) {
    self.path = path
    self.payload = payload

    var decodedArguments = [String: String]()
    arguments.forEach { (key, value) in
      decodedArguments[key] = PercentEncoder.decode(string: value)
    }

    self.arguments = decodedArguments
  }
}
