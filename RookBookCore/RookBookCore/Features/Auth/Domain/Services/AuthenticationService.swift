// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public protocol AuthenticationService {
    func login(with credentials: SignInCredentials) -> AnyPublisher<User, Error>
    func register(with credentials: SignUpCredentials) -> AnyPublisher<User, Error>
    func logout() -> AnyPublisher<Void, Error>
}
