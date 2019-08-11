import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(Lateral_Business_Logic_Tests.allTests),
  ]
}
#endif
