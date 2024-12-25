// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

public protocol StorableItem {
    associatedtype Identifier: StringConvertible
    var id: Identifier { get }
}
