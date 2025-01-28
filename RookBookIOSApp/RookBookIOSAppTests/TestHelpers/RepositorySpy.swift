// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import RookBookCore

final class RepositorySpy<Entity, Identifier: StringConvertible>: Repository {
    // MARK: - Captured Calls
    enum Message: Equatable {
        static func ==(lhs: RepositorySpy<Entity, Identifier>.Message,
                       rhs: RepositorySpy<Entity, Identifier>.Message) -> Bool {
            switch (lhs, rhs) {
            case let (.fetchWithID(id1), .fetchWithID(id2)):
                return id1 == id2
            case let (.save(entity1), .save(entity2)):
                if let entity1 = entity1 as? AnyHashable, let entity2 = entity2 as? AnyHashable {
                    return entity1 == entity2
                }
                return false
            case let (.delete(id1), .delete(id2)):
                return id1 == id2
            case let (.update(entity1), .update(entity2)):
                if let entity1 = entity1 as? AnyHashable, let entity2 = entity2 as? AnyHashable {
                    return entity1 == entity2
                }
                return false
            default:
                return false
            }
        }

        case fetch
        case fetchWithID(Identifier)
        case save(Entity)
        case delete(Identifier)
        case update(Entity)
    }

    private(set) var messages = [Message]()

    // MARK: - Results
    var fetchResult: AnyPublisher<[Entity], Error> = Empty().eraseToAnyPublisher()
    var fetchWithIDResult: AnyPublisher<Entity, Error> = Empty().eraseToAnyPublisher()
    var saveResult: AnyPublisher<Void, Error> = Empty().eraseToAnyPublisher()
    var deleteResult: AnyPublisher<Void, Error> = Empty().eraseToAnyPublisher()
    var updateResult: AnyPublisher<Void, Error> = Empty().eraseToAnyPublisher()

    // MARK: - Protocol Methods
    func fetch() -> AnyPublisher<[Entity], Error> {
        messages.append(.fetch)
        return fetchResult
    }

    func fetch(with id: Identifier) -> AnyPublisher<Entity, Error> {
        messages.append(.fetchWithID(id))
        return fetchWithIDResult
    }

    func save(_ entity: Entity) -> AnyPublisher<Void, Error> {
        messages.append(.save(entity))
        return saveResult
    }

    func delete(with id: Identifier) -> AnyPublisher<Void, Error> {
        messages.append(.delete(id))
        return deleteResult
    }

    func update(_ entity: Entity) -> AnyPublisher<Void, Error> {
        messages.append(.update(entity))
        return updateResult
    }
}
