import Foundation
import XCTest
import Compass

class TestCompass: XCTestCase {

  override func setUp() {
    Compass.scheme = "compassTests"
    Compass.routes = [
      "profile:{user}",
      "profile:admin",
      "login",
      "callback",
      "user:list:{userId}:{kind}",
      "user:list",
      "{appId}:user:list:{userId}:{kind}"
    ].shuffle()
  }

  func testScheme() {
    XCTAssertEqual(Compass.scheme, "compassTests://")
  }

  func testRoutes() {
    XCTAssert(!Compass.routes.isEmpty)
    XCTAssert(Compass.routes.count == 7)
  }

  func testParseArguments() {
    let expectation = self.expectationWithDescription("Parse arguments")
    let url = NSURL(string: "compassTests://profile:testUser")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual("profile:{user}", route)
      XCTAssertEqual(arguments["user"], "testUser")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseFragments() {
    let expectation = self.expectationWithDescription("Parse arguments")
    let url = NSURL(string: "compassTests://profile:testUser")!

    Compass.parse(url, fragments: ["meta" : "foo"]) { route, arguments, fragments in
      XCTAssertEqual("profile:{user}", route)
      XCTAssertEqual(arguments["user"], "testUser")
      XCTAssertEqual("foo" , fragments["meta"] as? String)

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRouteConcreateMatchCount() {
    let expectation = self.expectationWithDescription("Parse route having concrete match count")
    let url = NSURL(string: "compassTests://profile:admin")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual("profile:admin", route)
      XCTAssert(arguments.isEmpty)

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRouteWildcardMatchCount() {
    let expectation = self.expectationWithDescription("Parse route having wildcard match count")
    let url = NSURL(string: "compassTests://profile:jack")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual("profile:{user}", route)
      XCTAssertEqual(arguments["user"], "jack")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRouteSamePrefix() {
    let expectation = self.expectationWithDescription("Parse route having same prefix")
    let url = NSURL(string: "compassTests://user:list")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual("user:list", route)
      XCTAssert(arguments.isEmpty)

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseMultipleArguments() {
    let expectation = self.expectationWithDescription("Parse multiple arguments")
    let url = NSURL(string: "compassTests://user:list:1:admin")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual("user:list:{userId}:{kind}", route)
      XCTAssertEqual(arguments["userId"], "1")
      XCTAssertEqual(arguments["kind"], "admin")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseMultipleArgumentsWithFirstWildcard() {
    let expectation = self.expectationWithDescription("Parse multiple arguments with first wild card")
    let url = NSURL(string: "compassTests://12:user:list:1:admin")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual("{appId}:user:list:{userId}:{kind}", route)
      XCTAssertEqual(arguments["appId"], "12")
      XCTAssertEqual(arguments["userId"], "1")
      XCTAssertEqual(arguments["kind"], "admin")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseWithoutArguments() {
    let expectation = self.expectationWithDescription("Parse without arguments")
    let url = NSURL(string: "compassTests://login")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual("login", route)
      XCTAssert(arguments.isEmpty)

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithFragments() {
    let expectation = self.expectationWithDescription("Parse URL with fragments")
    let url = NSURL(string: "compassTests://callback/#access_token=IjvcgrkQk1p7TyJxKa26rzM1wBMFZW6XoHK4t5Gkt1xQLTN8l7ppR0H3EZXpoP0uLAN49oCDqTHsvnEV&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "IjvcgrkQk1p7TyJxKa26rzM1wBMFZW6XoHK4t5Gkt1xQLTN8l7ppR0H3EZXpoP0uLAN49oCDqTHsvnEV")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithFragmentsAndGoogleOAuth2AccessToken() {
    let expectation = self.expectationWithDescription("Parse URL with fragments and Google OAuth 2.0 access token format")
    let url = NSURL(string: "compassTests://callback/#access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithFragmentsAndAlternativeAccessToken() {
    let expectation = self.expectationWithDescription("Parse URL with fragments and alternative access token format")
    let url = NSURL(string: "compassTests://callback/#access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithSlashQuery() {
    let expectation = self.expectationWithDescription("Parse URL with slash query")
    let url = NSURL(string: "compassTests://callback/?access_token=Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithSlashQueryAndGoogleOAuth2AccessToken() {
    let expectation = self.expectationWithDescription("Parse URL with slash query and Google OAuth 2.0 access token format")
    let url = NSURL(string: "compassTests://callback/?access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithSlashQueryAndAlternativeAccessToken() {
    let expectation = self.expectationWithDescription("Parse URL with slash query and alternative access token format")
    let url = NSURL(string: "compassTests://callback/?access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithQuery() {
    let expectation = self.expectationWithDescription("Parse URL with query")
    let url = NSURL(string: "compassTests://callback?access_token=Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithQueryAndGoogleOAuth2AccessToken() {
    let expectation = self.expectationWithDescription("Parse URL with query and Google OAuth 2.0 access token format")
    let url = NSURL(string: "compassTests://callback?access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }

  func testParseRegularURLWithQueryAndAlternativeAccessToken() {
    let expectation = self.expectationWithDescription("Parse URL with query and alternative access token format")
    let url = NSURL(string: "compassTests://callback?access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=&token_type=Bearer&expires_in=3600")!

    Compass.parse(url) { route, arguments, _ in
      XCTAssertEqual(route, "callback")
      XCTAssertEqual(arguments.count, 3)
      XCTAssertEqual(arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=")
      XCTAssertEqual(arguments["expires_in"], "3600")
      XCTAssertEqual(arguments["token_type"], "Bearer")

      expectation.fulfill()
    }

    self.waitForExpectationsWithTimeout(4.0, handler:nil)
  }
}
