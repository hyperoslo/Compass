import UIKit
import XCTest

class TestCompass: XCTestCase {

  override func setUp() {
    Compass.scheme = "compassTests"
    Compass.routes = ["profile:{user}", "login"]
  }

  func testScheme() {
    XCTAssertEqual(Compass.scheme, "compassTests://")
  }

  func testRoutes() {
    XCTAssert(!Compass.routes.isEmpty)
    XCTAssert(Compass.routes.count == 2)
    XCTAssertEqual(Compass.routes[0], "profile:{user}")
    XCTAssertEqual(Compass.routes[1], "login")
  }

  func testParseArguments() {
    let url = NSURL(string: "compassTests://profile:testUser")!
    Compass.parse(url) { route, arguments in
      XCTAssertEqual("profile:{user}", route)
      XCTAssertEqual(arguments["user"], "testUser")
    }
  }

  func testParseOptionalArguments() {
    let url = NSURL(string: "compassTests://profile")!
    Compass.parse(url) { route, arguments in
      XCTAssertEqual("profile:{user}", route)
      XCTAssert(arguments.isEmpty)
    }
  }

  func testParseWithoutArguments() {
    let url = NSURL(string: "compassTest://login")!
    Compass.parse(url) { route, arguments in
      XCTAssertEqual("login", route)
      XCTAssert(arguments.isEmpty)
    }
  }
}
