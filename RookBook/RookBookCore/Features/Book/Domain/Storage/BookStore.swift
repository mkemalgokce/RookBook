// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public protocol BookStore: Storable where Item == Book, Identifier == UUID {}

extension DomainStoreDecorator: BookStore where Item == Book, Identifier == UUID {}
