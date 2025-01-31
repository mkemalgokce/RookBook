// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class AppleCredentialsTests: XCTestCase {
    // MARK: - Test Initialization
    func test_initialization_withValidValues_shouldSetPropertiesCorrectly() {
        let userIdentifier = "12345"
        let email = "test@example.com"
        let fullName = "John Doe"
        let authorizationCode = Data("authCode".utf8)
        let identityToken = Data("identityToken".utf8)

        let appleCredentials = AppleCredentials(
            userIdentifier: userIdentifier,
            email: email,
            fullName: fullName,
            authorizationCode: authorizationCode,
            identityToken: identityToken
        )

        XCTAssertEqual(appleCredentials.userIdentifier, userIdentifier)
        XCTAssertEqual(appleCredentials.email, email)
        XCTAssertEqual(appleCredentials.fullName, fullName)
        XCTAssertEqual(appleCredentials.authorizationCode, authorizationCode)
        XCTAssertEqual(appleCredentials.identityToken, identityToken)
    }

    // MARK: - Test toStringDictionary
    func test_toStringDictionary_shouldReturnCorrectDictionary() {
        let userIdentifier = "12345"
        let email = "test@example.com"
        let fullName = "John Doe"
        let authorizationCode = Data("authCode".utf8)
        let identityToken = Data("identityToken".utf8)

        let appleCredentials = AppleCredentials(
            userIdentifier: userIdentifier,
            email: email,
            fullName: fullName,
            authorizationCode: authorizationCode,
            identityToken: identityToken
        )

        let dictionary = appleCredentials.toStringDictionary()

        XCTAssertEqual(dictionary["userIdentifier"] as? String, userIdentifier)
        XCTAssertEqual(dictionary["email"] as? String, email)
        XCTAssertEqual(dictionary["fullName"] as? String, fullName)
        XCTAssertEqual(dictionary["authorizationCode"] as? String, authorizationCode.base64EncodedString())
        XCTAssertEqual(dictionary["identityToken"] as? String, identityToken.base64EncodedString())
    }

    // MARK: - Test toStringDictionary with nil values
    func test_toStringDictionary_shouldHandleNilValuesCorrectly() {
        let userIdentifier = "12345"
        let appleCredentials = AppleCredentials(
            userIdentifier: userIdentifier,
            email: nil,
            fullName: nil,
            authorizationCode: nil,
            identityToken: nil
        )

        let dictionary = appleCredentials.toStringDictionary()

        XCTAssertEqual(dictionary["userIdentifier"] as? String, userIdentifier)
        XCTAssertNil(dictionary["email"] as? String)
        XCTAssertNil(dictionary["fullName"] as? String)
        XCTAssertNil(dictionary["authorizationCode"] as? Data)
        XCTAssertNil(dictionary["identityToken"] as? String)
    }
}
