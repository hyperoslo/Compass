import Foundation
import XCTest
import Compass

class TestRoute: Routable {

  var resolved = false

  func resolve(arguments: [String: String], fragments: [String : AnyObject] = [:], currentController controller: Controller) {
    resolved = true
  }
}

class RouterTests: XCTestCase {

  var router: Router!
  var controller = Controller()
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
