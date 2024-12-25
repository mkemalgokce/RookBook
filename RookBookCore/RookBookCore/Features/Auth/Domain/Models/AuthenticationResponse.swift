// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

struct AuthenticationResponse {
    // MARK: - Properties
    let accessToken: Token
    let refreshToken: Token
    let user: User
}
