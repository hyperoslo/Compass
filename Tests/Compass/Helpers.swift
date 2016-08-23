import Foundation
@testable import Compass

// MARK: - Routes

class TestRoute: Routable {

  var resolved = false

  func navigate(to location: Location, from currentController: Controller) {
    resolved = true
  }
}

// MARK: - Shuffle

extension CollectionType {
  /// Return a copy of `self` with its elements shuffled
  func shuffle() -> [Generator.Element] {
    var list = Array(self)
    list.shuffleInPlace()
    return list
  }
}

extension MutableCollectionType where Index == Int {
  /// Shuffle the elements of `self` in-place.
  mutating func shuffleInPlace() {
    // empty and single-element collections don't shuffle
    if count < 2 { return }

    for i in 0..<count - 1 {
      let j = Int(arc4random_uniform(UInt32(count - i))) + i
      guard i != j else { continue }
      (self[i], self[j]) = (self[j], self[i])
      // instead of swap(&self[i], &self[j])
    }
  }
}
