// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public protocol AuthenticationServiceConformable {
    func login(with credentials: SignInCredentials) -> AnyPublisher<AuthenticatedUser, Error>
    func register(with credentials: SignUpCredentials) -> AnyPublisher<AuthenticatedUser, Error>
    func logout() -> AnyPublisher<Void, Error>
}
