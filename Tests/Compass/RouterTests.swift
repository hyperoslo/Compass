import Foundation
import XCTest
@testable import Compass

class RouterTests: XCTestCase {

  var router: Router!
  var route: TestRoute!
  var controller: Controller!

  override func setUp() {
    router = Router()
    route = TestRoute()
    controller = Controller()
  }

  func testNavigateIfRouteRegistered() {
    router.routes["test"] = route
    router.navigate(to: Location(path: "test"), from: controller)

    XCTAssertTrue(route.resolved)
  }

  func testNavigateIfRouteNotRegistered() {
    router.navigate(to: Location(path: "test"), from: controller)

    XCTAssertFalse(route.resolved)
  }
}
