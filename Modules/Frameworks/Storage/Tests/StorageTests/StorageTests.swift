import XCTest
@testable import Storage

final class StorageTests: XCTestCase {

    private var storage: Storage!
    private let testIdentifier = "com.example.testStorage"

    override func setUp() {
        super.setUp()
        storage = Storage(identifier: testIdentifier)
        storage.clear()
    }

    override func tearDown() {
        super.tearDown()
        storage.clear()
        storage = nil
    }

    func testAddAndRetrieveSimpleValue() {
        let key = "testStringKey"
        let testValue = "Hello world"

        // We add the value
        storage.add(value: testValue, forKey: key)

        // We attempt to retrieve the value
        let retrieved: String? = storage.value(forKey: key, type: String.self)

        XCTAssertNotNil(retrieved, "The retrieved value should not be nil")
        XCTAssertEqual(retrieved, testValue, "The retrieved value should be equal to the inserted value")
    }

    func testAddAndRetrieveComplexValue() {
        struct CustomModel: Codable, Equatable {
            let name: String
            let age: Int
        }

        let key = "customModelKey"
        let model = CustomModel(name: "Walter", age: 30)

        // We add the codable value
        storage.add(value: model, forKey: key)

        // We attempt to retrieve the value
        let retrieved: CustomModel? = storage.value(forKey: key, type: CustomModel.self)

        XCTAssertNotNil(retrieved, "The retrieved model should not be nil")
        XCTAssertEqual(retrieved, model, "The retrieved model should be equal to the inserted model")
    }

    func testRemoveValue() {
        let key = "testToRemoveKey"
        let testValue = "Value to remove"

        storage.add(value: testValue, forKey: key)
        var retrieved: String? = storage.value(forKey: key, type: String.self)
        XCTAssertEqual(retrieved, testValue)

        storage.removeValue(forKey: key)

        retrieved = storage.value(forKey: key, type: String.self)
        XCTAssertNil(retrieved, "The value should be nil after being removed")
    }

    func testClearAllValues() {
        // We add several values
        storage.add(value: "One", forKey: "key1")
        storage.add(value: 123, forKey: "key2")
        storage.add(value: true, forKey: "key3")

        // We ensure that they were saved
        XCTAssertNotNil(storage.value(forKey: "key1", type: String.self))
        XCTAssertNotNil(storage.value(forKey: "key2", type: Int.self))
        XCTAssertNotNil(storage.value(forKey: "key3", type: Bool.self))

        // We clear everything
        storage.clear()

        // Now they should all be nil
        XCTAssertNil(storage.value(forKey: "key1", type: String.self))
        XCTAssertNil(storage.value(forKey: "key2", type: Int.self))
        XCTAssertNil(storage.value(forKey: "key3", type: Bool.self))
    }
}
