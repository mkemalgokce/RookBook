// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

struct AuthenticatedUserDTO: Codable {
    // MARK: - Properties
    let id: UUID
    let email: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name = "fullName"
    }
}
