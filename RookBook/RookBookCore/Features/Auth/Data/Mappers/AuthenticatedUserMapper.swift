// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

enum AuthenticatedUserMapper {
    // MARK: - Static Methods
    static func map(_ dto: AuthenticatedUserDTO) -> AuthenticatedUser {
        AuthenticatedUser(id: dto.id.stringValue, email: dto.email, name: dto.name)
    }

    static func map(_ model: AuthenticatedUser) -> AuthenticatedUserDTO? {
        guard let id = UUID(uuidString: model.id), let email = model.email, let name = model.name else { return nil }
        return AuthenticatedUserDTO(id: id, email: email, name: name)
    }
}
