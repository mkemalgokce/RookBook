@testable import RookBookCore
import XCTest

final class EmailSignInCredentialsTests: XCTestCase {
    // MARK: - Initialization Tests
    func test_init_setsPropertiesCorrectly() {
        let email = "test@example.com"
        let password = "securePassword123"

        let credentials = EmailSignInCredentials(email: email, password: password)

        XCTAssertEqual(credentials.email, email, "Email property should be set correctly")
        XCTAssertEqual(credentials.password, password, "Password property should be set correctly")
    }

    // MARK: - `toStringDictionary` Tests
    func test_toStringDictionary_returnsCorrectDictionary() {
        let email = "test@example.com"
        let password = "securePassword123"
        let credentials = EmailSignInCredentials(email: email, password: password)

        let dictionary = credentials.toStringDictionary()

        XCTAssertEqual(dictionary["email"] as? String, email, "The dictionary should contain the correct email")
        XCTAssertEqual(
            dictionary["password"] as? String,
            password,
            "The dictionary should contain the correct password"
        )
    }

    // MARK: - Edge Case Tests
    func test_toStringDictionary_withEmptyValues() {
        let email = ""
        let password = ""
        let credentials = EmailSignInCredentials(email: email, password: password)

        let dictionary = credentials.toStringDictionary()

        XCTAssertEqual(
            dictionary["email"] as? String,
            email,
            "The dictionary should contain the correct email, even if empty"
        )
        XCTAssertEqual(
            dictionary["password"] as? String,
            password,
            "The dictionary should contain the correct password, even if empty"
        )
    }
}
