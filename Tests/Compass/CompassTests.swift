import Foundation
import XCTest
import Compass

class CompassTests: XCTestCase {

  override func setUp() {
    Navigator.scheme = "compassTests"
    Navigator.routes = [
      "profile:{user}",
      "profile:admin",
      "login",
      "callback",
      "organization:{name}:{type}",
      "user:list:{userId}:{kind}",
      "user:list",
      "{appId}:user:list:{userId}:{kind}"
    ].shuffle()
  }

  func testScheme() {
    XCTAssertEqual(Navigator.scheme, "compassTests://")
  }

  func testRoutes() {
    XCTAssert(!Navigator.routes.isEmpty)
    XCTAssert(Navigator.routes.count == 8)
  }

  func testParseArguments() {
    let url = URL(string: "compassTests://profile:testUser")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual("profile:{user}", location.path)
    XCTAssertEqual(location.arguments["user"], "testUser")
  }

  func testParsePayload() {
    let url = URL(string: "compassTests://profile:testUser")!

    typealias Payload = (firstName: String, lastName: String)

    guard let location = Navigator.parse(url: url, payload: Payload(firstName: "foo", lastName: "bar")) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual("profile:{user}", location.path)
    XCTAssertEqual(location.arguments["user"], "testUser")
    XCTAssertEqual("foo" , (location.payload as? Payload)?.firstName)
    XCTAssertEqual("bar" , (location.payload as? Payload)?.lastName)
  }

  func testParseRouteConcreateMatchCount() {
    let url = URL(string: "compassTests://profile:admin")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual("profile:admin", location.path)
    XCTAssert(location.arguments.isEmpty)
  }

  func testParseRouteWildcardMatchCount() {
    let url = URL(string: "compassTests://profile:jack")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual("profile:{user}", location.path)
    XCTAssertEqual(location.arguments["user"], "jack")
  }

  func testParseRouteSamePrefix() {
    let url = URL(string: "compassTests://user:list")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual("user:list", location.path)
    XCTAssert(location.arguments.isEmpty)
  }

  func testParseMultipleArguments() {
    let url = URL(string: "compassTests://user:list:1:admin")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual("user:list:{userId}:{kind}", location.path)
    XCTAssertEqual(location.arguments["userId"], "1")
    XCTAssertEqual(location.arguments["kind"], "admin")
  }

  func testParseMultipleArgumentsWithFirstWildcard() {
    let url = URL(string: "compassTests://12:user:list:1:admin")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual("{appId}:user:list:{userId}:{kind}", location.path)
    XCTAssertEqual(location.arguments["appId"], "12")
    XCTAssertEqual(location.arguments["userId"], "1")
    XCTAssertEqual(location.arguments["kind"], "admin")
  }

  func testParseWithoutArguments() {
    let url = URL(string: "compassTests://login")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual("login", location.path)
    XCTAssert(location.arguments.isEmpty)
  }

  func testParseRegularURLWithFragments() {
    let url = URL(string: "compassTests://callback/#access_token=IjvcgrkQk1p7TyJxKa26rzM1wBMFZW6XoHK4t5Gkt1xQLTN8l7ppR0H3EZXpoP0uLAN49oCDqTHsvnEV&token_type=Bearer&expires_in=3600")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual(location.path, "callback")
    XCTAssertEqual(location.arguments.count, 3)
    XCTAssertEqual(location.arguments["access_token"], "IjvcgrkQk1p7TyJxKa26rzM1wBMFZW6XoHK4t5Gkt1xQLTN8l7ppR0H3EZXpoP0uLAN49oCDqTHsvnEV")
    XCTAssertEqual(location.arguments["expires_in"], "3600")
    XCTAssertEqual(location.arguments["token_type"], "Bearer")
  }

  func testParseRegularURLWithFragmentsAndGoogleOAuth2AccessToken() {
    let url = URL(string: "compassTests://callback/#access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ&token_type=Bearer&expires_in=3600")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual(location.path, "callback")
    XCTAssertEqual(location.arguments.count, 3)
    XCTAssertEqual(location.arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ")
    XCTAssertEqual(location.arguments["expires_in"], "3600")
    XCTAssertEqual(location.arguments["token_type"], "Bearer")
  }

  func testParseRegularURLWithFragmentsAndAlternativeAccessToken() {
    let url = URL(string: "compassTests://callback/#access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=&token_type=Bearer&expires_in=3600")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual(location.path, "callback")
    XCTAssertEqual(location.arguments.count, 3)
    XCTAssertEqual(location.arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=")
    XCTAssertEqual(location.arguments["expires_in"], "3600")
    XCTAssertEqual(location.arguments["token_type"], "Bearer")
  }

  func testParseRegularURLWithSlashQuery() {
    let url = URL(string: "compassTests://callback/?access_token=Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l&token_type=Bearer&expires_in=3600")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual(location.path, "callback")
    XCTAssertEqual(location.arguments.count, 3)
    XCTAssertEqual(location.arguments["access_token"], "Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l")
    XCTAssertEqual(location.arguments["expires_in"], "3600")
    XCTAssertEqual(location.arguments["token_type"], "Bearer")
  }

  func testParseRegularURLWithSlashQueryAndGoogleOAuth2AccessToken() {
    let url = URL(string: "compassTests://callback/?access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ&token_type=Bearer&expires_in=3600")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual(location.path, "callback")
    XCTAssertEqual(location.arguments.count, 3)
    XCTAssertEqual(location.arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ")
    XCTAssertEqual(location.arguments["expires_in"], "3600")
    XCTAssertEqual(location.arguments["token_type"], "Bearer")
  }

  func testParseRegularURLWithSlashQueryAndAlternativeAccessToken() {
    let url = URL(string: "compassTests://callback/?access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=&token_type=Bearer&expires_in=3600")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual(location.path, "callback")
    XCTAssertEqual(location.arguments.count, 3)
    XCTAssertEqual(location.arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=")
    XCTAssertEqual(location.arguments["expires_in"], "3600")
    XCTAssertEqual(location.arguments["token_type"], "Bearer")
  }

  func testParseRegularURLWithQuery() {
    let url = URL(string: "compassTests://callback?access_token=Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l&token_type=Bearer&expires_in=3600")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual(location.path, "callback")
    XCTAssertEqual(location.arguments.count, 3)
    XCTAssertEqual(location.arguments["access_token"], "Yo0OMrVZbRWNmgA6BT99hyuTUTNRGvqEEAQyeN1eslclzhFD0M8AidB4Z7Vs2NU8WoSNW0vYb961O38l")
    XCTAssertEqual(location.arguments["expires_in"], "3600")
    XCTAssertEqual(location.arguments["token_type"], "Bearer")
  }

  func testParseRegularURLWithQueryAndGoogleOAuth2AccessToken() {
    let url = URL(string: "compassTests://callback?access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ&token_type=Bearer&expires_in=3600")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual(location.path, "callback")
    XCTAssertEqual(location.arguments.count, 3)
    XCTAssertEqual(location.arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ")
    XCTAssertEqual(location.arguments["expires_in"], "3600")
    XCTAssertEqual(location.arguments["token_type"], "Bearer")
  }

  func testParseRegularURLWithQueryAndAlternativeAccessToken() {
    let url = URL(string: "compassTests://callback?access_token=ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=&token_type=Bearer&expires_in=3600")!

    guard let location = Navigator.parse(url: url) else {
      XCTFail("Compass parsing failed")
      return
    }

    XCTAssertEqual(location.path, "callback")
    XCTAssertEqual(location.arguments.count, 3)
    XCTAssertEqual(location.arguments["access_token"], "ya29.Ci8nA1pNVMFffHkS5-sXooNGvTB9q8QPtoM56sWpipRyjhwwEiKyZxvRQTR8saqWzQ=")
    XCTAssertEqual(location.arguments["expires_in"], "3600")
    XCTAssertEqual(location.arguments["token_type"], "Bearer")
  }

  func testParseEncodedURL() {
    let urn = "organization:hyper oslo:simply awesome"
    Navigator.handle = { location in
      XCTAssertEqual(location.arguments["name"], "hyper oslo")
      XCTAssertEqual(location.arguments["type"], "simply awesome")
    }

    try? Navigator.navigate(urn: urn)

    wait(for: 0.1)
  }
}
