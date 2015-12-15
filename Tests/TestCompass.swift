import UIKit
import XCTest
import Compass

class TestCompass: XCTestCase {

  override func setUp() {
    Compass.scheme = "compassTests"
    Compass.routes = ["profile:{user}", "login", "callback"]
  }

  func testScheme() {
    XCTAssertEqual(Compass.scheme, "compassTests://")
  }

  func testRoutes() {
    XCTAssert(!Compass.routes.isEmpty)
    XCTAssert(Compass.routes.count == 3)
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
    let url = NSURL(string: "compassTests://login")!
    Compass.parse(url) { route, arguments in
      XCTAssertEqual("login", route)
      XCTAssert(arguments.isEmpty)
    }
  }

  func testParseRegularURLWithFragments() {
    let url = NSURL(string: "compassTests://callback/#access_token=IjvcgrkQk1p7TyJxKa26rzM1wBMFZW6XoHK4t5Gkt1xQLTN8l7ppR0H3EZXpoP0uLAN49oCDqTHsvnEV&token_type=Bearer&expires_in=3600")!
    Compass.parse(url) { route, arguments in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "IjvcgrkQk1p7TyJxKa26rzM1wBMFZW6XoHK4t5Gkt1xQLTN8l7ppR0H3EZXpoP0uLAN49oCDqTHsvnEV")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")
    }
  }

  func testParseRegularURLWithQuery() {
    let url = NSURL(string: "compassTests://callback/?access_token=Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l&token_type=Bearer&expires_in=3600")!
    Compass.parse(url) { route, arguments in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")
    }
  }
}
