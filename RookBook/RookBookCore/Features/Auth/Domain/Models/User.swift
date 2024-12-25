// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

public protocol User: StringDictionaryConvertible {
    var id: String { get }
    var email: String? { get }
    var name: String? { get }
}
