import Foundation
import XCTest
@testable import Compass

class UtilitiesTests: XCTestCase {
  func testEncode() {
    let urn = "organization:hyper oslo:simply awesome"
    let encodedUrn = PercentEncoder.encode(string: urn, allowed: ":")

    XCTAssertEqual(encodedUrn, "organization:hyper%20oslo:simply%20awesome")
  }

  func testDecode() {
    let urn = "organization:hyper oslo:simply awesome"
    let encodedUrn = PercentEncoder.encode(string: urn, allowed: ":")

    XCTAssertEqual(PercentEncoder.decode(string: encodedUrn), urn)
  }
}
