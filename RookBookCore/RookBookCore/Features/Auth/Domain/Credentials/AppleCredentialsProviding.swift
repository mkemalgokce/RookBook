// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public protocol AppleCredentialsProviding {
    func provide() -> AnyPublisher<AppleCredentials, Error>
}
