// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class KeychainTokenStoreTests: XCTestCase {
    override func tearDown() {
        deleteKeychain()
    }

    func test_store_throwsErrorWhenTokenIsInvalid() {
        let sut = makeSUT()
        let token = Token("")

        expectError(
            onAction: { _ = try sut.store(token: token) },
            expectedError: KeychainTokenStore.KeychainError.invalidItem
        )
    }

    func test_store_savesSuccessfully() throws {
        let sut = makeSUT()
        let token = Token("test-auth-token")

        XCTAssertNoThrow(try sut.store(token: token), "Token should be saved without errors")

        let storedToken = try sut.get()
        XCTAssertEqual(storedToken.value, token.value, "Saved token should match the retrieved token")
    }

    func test_get_ThrowsWhenNoTokenExists() throws {
        let sut = makeSUT()

        expectError(
            onAction: { _ = try sut.get() },
            expectedError: KeychainTokenStore.KeychainError.itemNotFound
        )
    }

    func test_store_updateTokenSuccessfully() throws {
        let sut = makeSUT()
        let initialToken = Token("initial-token")
        let updatedToken = Token("updated-token")

        try sut.store(token: initialToken)
        try sut.store(token: updatedToken)

        let storedToken = try sut.get()
        XCTAssertEqual(storedToken.value, updatedToken.value, "Updated token should match the retrieved token")
    }

    func test_retrieve_throwsErrorWhenTokenIsInvalid() {
        let sut = makeSUT()
        insertInvalidDataToKeychain()

        expectError(
            onAction: { _ = try sut.get() },
            expectedError: KeychainTokenStore.KeychainError.invalidItem
        )
    }

    func test_clean_clearsTokenSuccessfully() throws {
        let sut = makeSUT()
        let token = Token("test-auth-token")

        try sut.store(token: token)
        try sut.clear()

        expectError(
            onAction: { _ = try sut.get() },
            expectedError: KeychainTokenStore.KeychainError.itemNotFound
        )
    }

    func test_clean_doesNotThrowWhenNoTokenExists() {
        let sut = makeSUT()

        XCTAssertNoThrow(try sut.clear(), "Cleaning should not throw when no token exists")
    }

    // MARK: - Helpers
    private func makeSUT(withIdentifier identifier: String = "any", file: StaticString = #file,
                         line: UInt = #line) -> KeychainTokenStore {
        let sut = KeychainTokenStore(identifier: identifier)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func deleteKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainTokenStore.Constants.service
        ]
        SecItemDelete(query as CFDictionary)
    }

    private func insertInvalidDataToKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainTokenStore.Constants.service,
            kSecAttrAccount as String: "any",
            kSecValueData as String: Data()
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func expectError(
        onAction action: () throws -> Void,
        expectedError: Error,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        do {
            try action()
            XCTFail("It should have thrown an error", file: file, line: line)
        } catch {
            XCTAssertEqual(
                error as NSError,
                expectedError as NSError,
                "Error should be \(expectedError) but got \(error)",
                file: file, line: line
            )
        }
    }

    private enum KeychainWrapper {
        static var addItem: (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus = SecItemAdd
        static var updateItem: (CFDictionary, CFDictionary) -> OSStatus = SecItemUpdate
        static var deleteItem: (CFDictionary) -> OSStatus = SecItemDelete
        static var copyMatching: (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus = SecItemCopyMatching
    }
}
