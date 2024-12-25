// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

@testable import RookBookCore
import XCTest

final class AuthenticatedUserMapperTests: XCTestCase {
    func test_map_createsAuthenticatedUser() {
        let dto = AuthenticatedUserDTO(id: UUID(), email: "any@mail.com", name: "any name")
        let mapped = AuthenticatedUserMapper.map(dto)
        XCTAssertEqual(mapped.id, dto.id.uuidString)
        XCTAssertEqual(mapped.email, dto.email)
        XCTAssertEqual(mapped.name, dto.name)
    }

    func test_map_createsAuthenticatedUserDTO() {
        let authenticatedUser = AuthenticatedUser(id: UUID().uuidString, email: "any@mail.com", name: "any name")
        let mapped = AuthenticatedUserMapper.map(authenticatedUser)

        XCTAssertEqual(mapped?.id, UUID(uuidString: authenticatedUser.id))
        XCTAssertEqual(mapped?.email, authenticatedUser.email)
        XCTAssertEqual(mapped?.name, authenticatedUser.name)
    }

    func test_map_returnsNilWhenIDisNotUUID() {
        let authenticatedUser = AuthenticatedUser(id: "invalid", email: "any@mail.com", name: "any name")
        let mapped = AuthenticatedUserMapper.map(authenticatedUser)
        XCTAssertNil(mapped)
    }

    func test_map_returnsNilWhenEmailIsNil() {
        let authenticatedUser = AuthenticatedUser(id: UUID().uuidString, email: nil, name: "any name")
        let mapped = AuthenticatedUserMapper.map(authenticatedUser)
        XCTAssertNil(mapped)
    }

    func test_map_returnsNilWhenNameIsNil() {
        let authenticatedUser = AuthenticatedUser(id: UUID().uuidString, email: "any@mail.com", name: nil)
        let mapped = AuthenticatedUserMapper.map(authenticatedUser)
        XCTAssertNil(mapped)
    }
}
