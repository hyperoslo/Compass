import Foundation
import XCTest
@testable import Compass

class RouterTests: XCTestCase {

  var router: Router!
  var route: TestRoute!
  var controller: CurrentController!
  var errorRoute: ErrorRoute!

  override func setUp() {
    router = Router()
    route = TestRoute()
    controller = CurrentController()
    errorRoute = ErrorRoute()

    router.errorRoute = errorRoute
  }

  func testNavigateIfRouteRegistered() {
    router.routes["test"] = route
    router.navigate(to: Location(path: "test"), from: controller)

    XCTAssertTrue(route.resolved)
    XCTAssertNil(errorRoute.error)
  }

  func testNavigateIfRouteNotRegistered() {
    router.navigate(to: Location(path: "test"), from: controller)

    XCTAssertFalse(route.resolved)
    XCTAssertTrue(errorRoute.error is RouteError)
  }

  func testNavigateIfRouteThrowsError() {
    router.routes["throw"] = ThrowableRoute()
    router.navigate(to: Location(path: "throw"), from: controller)

    XCTAssertTrue(errorRoute.error is ThrowableRoute.InternalError)
  }
}
