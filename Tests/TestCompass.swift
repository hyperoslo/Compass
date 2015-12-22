import UIKit
import XCTest
import Compass

class TestCompass: XCTestCase {

  override func setUp() {
    Compass.scheme = "compassTests"
    Compass.routes = ["profile:{user}", "login", "callback", "user:list:{userId}:{kind}"]
  }

  func testScheme() {
    XCTAssertEqual(Compass.scheme, "compassTests://")
  }

  func testRoutes() {
    XCTAssert(!Compass.routes.isEmpty)
    XCTAssert(Compass.routes.count == 4)
    XCTAssertEqual(Compass.routes[0], "profile:{user}")
    XCTAssertEqual(Compass.routes[1], "login")
  }

  func testParseArguments() {
    let expectation = self.expectationWithDescription("Parse arguments")
    let url = NSURL(string: "compassTests://profile:testUser")!

    Compass.parse(url) { route, arguments in
      XCTAssertEqual("profile:{user}", route)
      XCTAssertEqual(arguments["user"], "testUser")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseMultipleArguments() {
    let expectation = self.expectationWithDescription("Parse multiple arguments")
    let url = NSURL(string: "compassTests://user:list:1:admin")!

    Compass.parse(url) { route, arguments in
      XCTAssertEqual("user:list:{userId}:{kind}", route)
      XCTAssertEqual(arguments["userId"], "1")
      XCTAssertEqual(arguments["kind"], "admin")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseOptionalArguments() {
    let expectation = self.expectationWithDescription("Parse optional arguments")
    let url = NSURL(string: "compassTests://profile")!

    Compass.parse(url) { route, arguments in
      XCTAssertEqual("profile:{user}", route)
      XCTAssert(arguments.isEmpty)

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseWithoutArguments() {
    let expectation = self.expectationWithDescription("Parse without arguments")
    let url = NSURL(string: "compassTests://login")!

    Compass.parse(url) { route, arguments in
      XCTAssertEqual("login", route)
      XCTAssert(arguments.isEmpty)

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithFragments() {
    let expectation = self.expectationWithDescription("Parse URL with fragments")
    let url = NSURL(string: "compassTests://callback/#access_token=IjvcgrkQk1p7TyJxKa26rzM1wBMFZW6XoHK4t5Gkt1xQLTN8l7ppR0H3EZXpoP0uLAN49oCDqTHsvnEV&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "IjvcgrkQk1p7TyJxKa26rzM1wBMFZW6XoHK4t5Gkt1xQLTN8l7ppR0H3EZXpoP0uLAN49oCDqTHsvnEV")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithQuery() {
    let expectation = self.expectationWithDescription("Parse URL with query")
    let url = NSURL(string: "compassTests://callback/?access_token=Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }
}
