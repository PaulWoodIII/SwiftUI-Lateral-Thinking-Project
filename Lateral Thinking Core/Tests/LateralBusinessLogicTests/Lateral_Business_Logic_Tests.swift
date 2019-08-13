import XCTest
import Combine
import CombineFeedback
import Entwine
import EntwineTest
import LateralThinkingCore
import GameplayKit
@testable import LateralBusinessLogic

final class Lateral_Business_Logic_Tests: XCTestCase {
  
  typealias State = CardViewModel.State

  func testSetLaterals() {
    let testScheduler = CombineFeedback.TestScheduler()
    let testString = "A Test Lateral"
    let testLateral: LateralType = LateralType(stringLiteral: testString)
    let lateralPublisher = PassthroughSubject<[LateralType], Never>()
    let initialState = State()
    let sut = CardViewModel(initial: initialState,
                            lateralPublisher: lateralPublisher.share().subscribe(on: testScheduler).receive(on: testScheduler).eraseToAnyPublisher(),
                            scheduler: testScheduler)
   
    var value: State?
    _ = sut.state.sink(receiveValue: { value = $0})
    testScheduler.advance()
    XCTAssertEqual(value, initialState, "returns initial state")
    lateralPublisher.send([testLateral])
    testScheduler.advance()
    let stateWithTestLateral = State().set(\.displayLaterals, [testLateral])
      .set(\.displayText, testString)
    XCTAssertEqual(value, stateWithTestLateral,  "returns display laterals set and sets the display lateral")
  }
  
  func testTap() {
    let test1Lateral: LateralType = "A Test1 Lateral"
    let test2Lateral: LateralType = "A Test2 Lateral"
    let stateWithTestLateral = State().set(\.displayLaterals, [test1Lateral, test2Lateral])
      .set(\.shuffler, GKShuffledDistribution(lowestValue: 0, highestValue: 0))
    let afterTap = CardViewModel.reduce(state: stateWithTestLateral, event: .onTap)
    XCTAssertEqual(afterTap.displayText, test1Lateral.body)
  }
  
  static var allTests = [
    ("testSetLaterals", testSetLaterals),
  ]
}

