// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public protocol BookStore: Storable, CacheStorable where Item == LocalBook, Identifier == UUID {}
