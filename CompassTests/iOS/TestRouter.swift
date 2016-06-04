import Foundation
import XCTest
import Compass

class TestRoute: Routable {

  var resolved = false

  func resolve(arguments: [String: String], fragments: [String : AnyObject] = [:], currentController controller: UIViewController) {
    resolved = true
  }
}

class TestRouter: XCTestCase {

  var router: Router!
  var controller = UIViewController()
  var route: TestRoute!

  override func setUp() {
    router = Router()
    route = TestRoute()
  }

  func testNavigateIfRouteRegistered() {
    router.routes["test"] = route
    router.navigate("test", arguments: [:], from: controller)

    XCTAssertTrue(route.resolved)
  }

  func testNavigateIfRouteNotRegistered() {
    router.navigate("test", arguments: [:], from: controller)

    XCTAssertFalse(route.resolved)
  }
}
