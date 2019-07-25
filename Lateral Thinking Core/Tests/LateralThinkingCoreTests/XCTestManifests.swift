import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Lateral_Thinking_CoreTests.allTests),
    ]
}
#endif
