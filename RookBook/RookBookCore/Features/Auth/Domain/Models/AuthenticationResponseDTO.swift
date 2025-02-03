// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

struct AuthenticationResponseDTO: Codable {
    let user: AuthenticatedUserDTO
    let accessToken: String
}
