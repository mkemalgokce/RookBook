// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public protocol Repository {
    associatedtype Entity
    associatedtype Identifier: StringConvertible
    func fetch() -> AnyPublisher<[Entity], Error>
    func fetch(with id: Identifier) -> AnyPublisher<Entity, Error>
    func save(_ entity: Entity) -> AnyPublisher<Void, Error>
    func delete(with id: Identifier) -> AnyPublisher<Void, Error>
    func update(_ entity: Entity) -> AnyPublisher<Void, Error>
}
