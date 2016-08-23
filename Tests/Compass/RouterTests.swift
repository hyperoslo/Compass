import Foundation
import XCTest
@testable import Compass

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
