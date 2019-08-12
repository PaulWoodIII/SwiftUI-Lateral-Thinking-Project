import XCTest
import Combine
import CombineFeedback
import Entwine
import EntwineTest
import LateralThinkingCore
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
    let stateWithOutTestLateral = State().set(\.displayLaterals, [testLateral])
      .set(\.displayText, testString)
    XCTAssertEqual(value, stateWithOutTestLateral,  "returns display laterals set and sets the display lateral")
  }
  
  static var allTests = [
    ("testSetLaterals", testSetLaterals),
  ]
}

