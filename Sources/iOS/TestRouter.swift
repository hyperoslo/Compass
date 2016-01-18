import Foundation
import XCTest
import Compass

class TestRoute: Routable {

  var resolved = false

  func resolve(arguments: [String: String], navigationController: UINavigationController) {
    resolved = true
  }
}

class TestRouter: XCTestCase {

  var router: Router!
  var navigationController = UINavigationController()
  var route: TestRoute!

  override func setUp() {
    router = Router()
    route = TestRoute()
  }

  func testNavigateIfRouteRegistered() {
    router.routes["test"] = route
    router.navigate("test", arguments: [:], navigationController: navigationController)

    XCTAssertTrue(route.resolved)
  }

  func testNavigateIfRouteNotRegistered() {
    router.navigate("test", arguments: [:], navigationController: navigationController)

    XCTAssertFalse(route.resolved)
  }
}
