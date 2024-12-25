// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public protocol TokenStorable {
    func store(token: Token) throws
    func get() throws -> Token
    func clear() throws
}
