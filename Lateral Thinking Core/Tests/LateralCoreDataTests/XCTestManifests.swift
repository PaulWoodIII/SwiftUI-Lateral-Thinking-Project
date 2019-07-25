
import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CoreDataServiceTests.allTests),
    ]
}
#endif
