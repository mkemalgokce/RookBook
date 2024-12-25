// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public final class KeychainTokenStore: TokenStorable {
    // MARK: - Nested Types
    enum Constants {
        static let service = "com.mustafakemalgokce.TokenStore"
    }

    enum KeychainError: Error {
        case invalidItem
        case itemNotFound
        case duplicateItem
        case unexpectedStatus(OSStatus)
    }

    // MARK: - Properties
    private let identifier: String

    // MARK: - Initializers
    public init(identifier: String) {
        self.identifier = identifier
    }

    // MARK: - Public Methods
    public func store(token: Token) throws {
        let data = try encode(token)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Constants.service,
            kSecAttrAccount as String: identifier,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecDuplicateItem {
            try updateToken(token)
        } else if status != errSecSuccess {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    public func clear() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Constants.service,
            kSecAttrAccount as String: identifier
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    public func get() throws -> Token {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Constants.service,
            kSecAttrAccount as String: identifier,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            throw status == errSecItemNotFound ? KeychainError.itemNotFound : KeychainError.unexpectedStatus(status)
        }

        return try decode(data)
    }

    // MARK: - Private Methods
    private func updateToken(_ token: Token) throws {
        let data = try encode(token)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Constants.service,
            kSecAttrAccount as String: identifier
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    private func encode(_ token: Token) throws -> Data {
        guard let data = token.value.data(using: .utf8), !token.value.isEmpty else {
            throw KeychainError.invalidItem
        }
        return data
    }

    private func decode(_ data: Data) throws -> Token {
        guard let string = String(data: data, encoding: .utf8), !string.isEmpty else {
            throw KeychainError.invalidItem
        }
        return Token(string)
    }
}
