// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class EmailSignUpCredentialsTests: XCTestCase {
    // MARK: - Initialization Tests
    func test_init_setsPropertiesCorrectly() {
        let name = "John Doe"
        let email = "john.doe@example.com"
        let password = "securePassword123"

        let credentials = EmailSignUpCredentials(name: name, email: email, password: password)

        XCTAssertEqual(credentials.name, name, "Name property should be set correctly")
        XCTAssertEqual(credentials.email, email, "Email property should be set correctly")
        XCTAssertEqual(credentials.password, password, "Password property should be set correctly")
    }

    // MARK: - toStringDictionary Tests
    func test_toStringDictionary_returnsCorrectDictionary() {
        let name = "John Doe"
        let email = "john.doe@example.com"
        let password = "securePassword123"
        let credentials = EmailSignUpCredentials(name: name, email: email, password: password)

        let dictionary = credentials.toStringDictionary()

        XCTAssertEqual(dictionary["name"] as? String, name, "The 'name' key should map to the correct value")
        XCTAssertEqual(dictionary["email"] as? String, email, "The 'email' key should map to the correct value")
        XCTAssertEqual(
            dictionary["password"] as? String,
            password,
            "The 'password' key should map to the correct value"
        )
    }
}
