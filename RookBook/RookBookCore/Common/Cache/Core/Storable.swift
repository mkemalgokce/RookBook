// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine

public protocol Storable {
    associatedtype Item
    associatedtype Identifier: StringConvertible

    func save(_ item: Item) throws
    func saveAll(_ items: [Item]) throws
    func loadAll() throws -> [Item]
    func deleteAll() throws
    func load(for identifier: Identifier) throws -> Item
    func delete(for identifier: Identifier) throws
    func update(_ item: Item) throws
}

extension Storable {
    func saveAllPublisher(_ items: [Item]) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                do {
                    try self.saveAll(items)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func savePublisher(_ item: Item) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                do {
                    try self.save(item)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func loadAllPublisher() -> AnyPublisher<[Item], Error> {
        Deferred {
            Future { promise in
                do {
                    let items = try self.loadAll()
                    promise(.success(items))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func deleteAllPublisher() -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                do {
                    try self.deleteAll()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func loadPublisher(for identifier: Identifier) -> AnyPublisher<Item, Error> {
        Deferred {
            Future { promise in
                do {
                    let item = try self.load(for: identifier)
                    promise(.success(item))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func deletePublisher(for identifier: Identifier) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                do {
                    try self.delete(for: identifier)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func updatePublisher(_ item: Item) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                do {
                    try self.update(item)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
